import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:flutter/services.dart';

class ModuleService extends BaseService {
  final CollectionReference _moduleCollectionReference =
      FirebaseFirestore.instance.collection('modules');

  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
  final BusinessService _businessService = locator<BusinessService>();

  final StreamController<List<Module>> _moduleController =
      StreamController<List<Module>>.broadcast();

  Future getModule(String moduleId) async {
    try {
      var userData = await _moduleCollectionReference.doc(moduleId).get();
      return new Module.fromJson(userData.data() as Map<String, dynamic>, moduleId);
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future allCourseModules(String courseId) async {
    try {
      List<Module> modules = new List.empty(growable: true);
      await _moduleCollectionReference
          .where("course_id", isEqualTo: courseId)
          .get()
          .then((value) => {
                value.docs.forEach(
                    (c) => modules.add(Module.fromJson(c.data() as Map<String, dynamic>, c.id)))
              });
      return modules;
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future addModule(Module module) async {
    try {
      populateCommonFields(object: module, created: true);
      //update business lesson count
      BusinessProfile profile =
          await _businessService.getBusinessProfile(module.businessId);

      profile.publication!.totalModuleCounts =
          profile.publication!.totalModuleCounts + 1;
      DocumentReference bpRef =
          _businessProfileCollectionReference.doc(profile.documentId);
      await _businessService.updateBusinessProfileStats(profile);

      return await _moduleCollectionReference.add(module.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getModulesOnceOff() async {
    try {
      var moduleDocumentSnapshot = await _moduleCollectionReference.get();
      if (moduleDocumentSnapshot.docs.isNotEmpty) {
        return moduleDocumentSnapshot.docs
            .map((snapshot) => Module.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Stream listenToModulesRealTime(String courseId) {
    // Register the handler for when the posts data changes

    _requestModules(courseId);
    return _moduleController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestModules(String courseId) {
    // #2: split the query from the actual subscription
    var pageModulesQuery = _moduleCollectionReference
        .where("course_id", isEqualTo: courseId)
        .orderBy('display_order');
    // #3: Limit the amount of results
    // .limit(ModulesLimit);

    // #5: If we have a document start the query after it
    /* if (_lastDocument != null) {
      pageModulesQuery = pageModulesQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreModules) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;
*/
    pageModulesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var modules = snapshot.docs
            .map((snapshot) => Module.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
/*
        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = modules;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(modules);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<Module>>(
            List<Module>.empty(growable: true),
            (initialValue, pageItems) => initialValue..addAll(pageItems));
*/
        // #12: Broadcase all posts
        _moduleController.add(modules);

        // #13: Save the last document from the results only if it's the current last page
        /* if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = snapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreModules = modules.length == ModulesLimit;*/
      }
    });
  }

  Future deleteModule(String documentId) async {
    try {
      return await _moduleCollectionReference.doc(documentId).delete();
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future updateModule(String id, Module module) async {
    try {
      await _moduleCollectionReference.doc(id).update(module.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  void requestMoreData(String courseId) => _requestModules(courseId);

  Future getAllBusinessPublishedModules(String businessId) async {
    try {
      var moduleDocumentSnapshot = await _moduleCollectionReference
          .where("business_id", isEqualTo: businessId)
          .where("published", isEqualTo: true)
          .orderBy("display_order")
          .get();
      if (moduleDocumentSnapshot.docs.isNotEmpty) {
        return moduleDocumentSnapshot.docs
            .map((snapshot) => Module.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
      return List.empty();
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }
}
