import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:flutter/services.dart';

class InstructorService extends BaseService {
  final StreamController<List<Instructor>> _instructorController =
      StreamController<List<Instructor>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Instructor>> _allPagedResults = List.empty(growable: true);

  static const int instructorsLimit = 20;

  Map<String, dynamic>? _lastDocument;
  bool _hasMorePosts = true;

  Future getInstructor(String documentId) async {
    try {
      var userData = await BaseService.supabaseDataService
          .fetchById('instructors', documentId);
      return new Instructor.fromJson(
          docId: documentId, json: userData as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getInstructorByName(String name) async {
    try {
      var userData = await BaseService.supabaseDataService
          .fetchAllWithQuery('instructors', where: {'full_name': name});
      if (userData.isNotEmpty) {
        return new Instructor.fromJson(
            docId: userData.first['id'] as String, json: userData.first);
      } else {
        return null;
      }
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future addInstructor(Instructor instructor) async {
    try {
      super.populateCommonFields(object: instructor, created: true);
      return await BaseService.supabaseDataService
          .insert('instructors', instructor.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getInstructoresOnceOff() async {
    try {
      var instructorDocumentSnapshot = await BaseService.supabaseDataService
          .fetchAllWithQuery('instructors', maxRows: instructorsLimit);
      if (instructorDocumentSnapshot.isNotEmpty) {
        return instructorDocumentSnapshot
            .map((snapshot) => Instructor.fromJson(
                docId: snapshot['id'] as String, json: snapshot))
            .where((mappedItem) => mappedItem.fullName != null)
            .toList();
      }
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Stream listenToInstructoresRealTime(String businessId) {
    // Register the handler for when the posts data changes
    _requestInstructores(businessId);
    return _instructorController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestInstructores(String businessId) {
    if (!_hasMorePosts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    // #2: split the query from the actual subscription
    _fetchAndUpdateInstructors(businessId, currentRequestIndex);
  }

  Future<void> _fetchAndUpdateInstructors(
      String businessId, int currentRequestIndex) async {
    try {
      // #5: If we have a document start the query after it
      //var offset = currentRequestIndex * instructorsLimit;

      var instructorData = await BaseService.supabaseDataService
          .fetchAllWithQuery('instructors',
              where: {'business_id': businessId},
              orderBy: 'full_name',
              maxRows: instructorsLimit);

      if (instructorData.isNotEmpty) {
        var cources = instructorData
            .map((snapshot) => Instructor.fromJson(
                docId: snapshot['id'] as String, json: snapshot))
            .where((mappedItem) => mappedItem.fullName != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = cources;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(cources);
        }

        // #11: Concatenate the full list to be shown
        var allInstructors = _allPagedResults.fold<List<Instructor>>(
            List<Instructor>.empty(growable: true),
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all Instructors
        _instructorController.add(allInstructors);

        // #14: Determine if there's more posts to request
        _hasMorePosts = cources.length == instructorsLimit;
      }
    } catch (e) {
      handleException(e as PlatformException);
    }
  }

  Future deleteInstructor(Instructor instructor) async {
    super.populateCommonFields(object: instructor, deleted: true);
    await BaseService.supabaseDataService
        .delete('instructors', instructor.documentId);
  }

  Future updateInstructor(String instructorId, Instructor instructor) async {
    try {
      super.populateCommonFields(object: instructor, created: false);
      await BaseService.supabaseDataService
          .update('instructors', instructorId, instructor.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  void requestMoreData(String businessId) => _requestInstructores(businessId);
}
