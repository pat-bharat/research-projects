import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:flutter/services.dart';

class InstructorService extends BaseService {
  final CollectionReference _instructorCollectionReference =
      FirebaseFirestore.instance.collection('instructors');

  final StreamController<List<Instructor>> _instructorController =
      StreamController<List<Instructor>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Instructor>> _allPagedResults = List.empty(growable: true);

  static const int instructorsLimit = 20;

  DocumentSnapshot? _lastDocument;
  bool _hasMorePosts = true;

  Future getInstructor(String documentId) async {
    try {
      var userData = await _instructorCollectionReference.doc(documentId).get();
      return new Instructor.fromJson(docId: documentId, json: userData.data() as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getInstructorByName(String name) async {
    try {
      var userData = await _instructorCollectionReference
          .where("full_name", isEqualTo: name)
          .get();
      if (userData.docs.isNotEmpty) {
        return new Instructor.fromJson(
            docId: userData.docs.first.id, json: userData.docs.first.data() as Map<String, dynamic>);
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
      DocumentReference ref =
          await _instructorCollectionReference.add(instructor.toJson());
      return ref.get();
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getInstructoresOnceOff() async {
    try {
      var instructorDocumentSnapshot =
          await _instructorCollectionReference.limit(instructorsLimit).get();
      if (instructorDocumentSnapshot.docs.isNotEmpty) {
        return instructorDocumentSnapshot.docs
            .map(
                (snapshot) => Instructor.fromJson(docId: snapshot.id, json: snapshot.data() as Map<String, dynamic>))
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
    // #2: split the query from the actual subscription
    var pageInstructoresQuery = _instructorCollectionReference
        .where("business_id", isEqualTo: businessId)
        .orderBy('full_name')
        // #3: Limit the amount of results
        .limit(instructorsLimit);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pageInstructoresQuery =
          pageInstructoresQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMorePosts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pageInstructoresQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var cources = snapshot.docs
            .map(
                (snapshot) => Instructor.fromJson(docId: snapshot.id, json: snapshot.data() as Map<String, dynamic>))
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

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = snapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = cources.length == instructorsLimit;
      }
    });
  }

  Future deleteInstructor(Instructor instructor) async {
    super.populateCommonFields(object: instructor, deleted: true);
    await _instructorCollectionReference.doc(instructor.documentId).delete();
  }

  Future updateInstructor(String instructorId, Instructor instructor) async {
    try {
      super.populateCommonFields(object: instructor, created: false);
      await _instructorCollectionReference
          .doc(instructorId)
          .update(instructor.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  void requestMoreData(String businessId) => _requestInstructores(businessId);
}
