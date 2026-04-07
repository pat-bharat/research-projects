import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:flutter/services.dart';

class ModuleService extends BaseService {
  /*final CollectionReference _moduleCollectionReference =
      FirebaseFirestore.instance.collection('modules');

  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
 */
  final BusinessService _businessService = locator<BusinessService>();

  final StreamController<List<Module>> _moduleController =
      StreamController<List<Module>>.broadcast();

  Future getModule(String moduleId) async {
    try {
      var userData =
          await BaseService.supabaseDataService.fetchById('modules', moduleId);
      return new Module.fromJson(userData as Map<String, dynamic>, moduleId);
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future allCourseModules(String courseId) async {
    try {
      List<Module> modules = new List.empty(growable: true);
      var result = await BaseService.supabaseDataService.fetchAllWithQuery(
          'modules',
          where: {'course_id': courseId},
          orderBy: 'created_timestamp',
          ascending: false);
      result.forEach((value) =>
          modules.add(Module.fromJson(value, value['id'] as String)));
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

      await _businessService.updateBusinessProfileStats(profile);

      return await BaseService.supabaseDataService
          .insert('modules', module.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future getModulesOnceOff() async {
    try {
      var result = await BaseService.supabaseDataService.fetchAllWithQuery(
          'modules',
          orderBy: 'created_timestamp',
          ascending: false);
      if (result.isNotEmpty) {
        return result
            .map((value) => Module.fromJson(value, value['id'] as String))
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
    var pageModulesQuery = BaseService.supabaseDataService.fetchAllWithQuery(
        'modules',
        where: {'course_id': courseId},
        orderBy: 'display_order',
        ascending: false);
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
    pageModulesQuery.asStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        var modules = snapshot
            .map((value) => Module.fromJson(value, value['id'] as String))
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
      return await BaseService.supabaseDataService
          .delete('modules', documentId);
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  Future updateModule(String id, Module module) async {
    try {
      await BaseService.supabaseDataService
          .update('modules', id, module.toJson());
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  void requestMoreData(String courseId) => _requestModules(courseId);

  Future getAllBusinessPublishedModules(String businessId) async {
    try {
      var result = await BaseService.supabaseDataService.fetchAllWithQuery(
          'modules',
          where: {'business_id': businessId, 'published': true},
          orderBy: 'display_order',
          ascending: false);
      if (result.isNotEmpty) {
        return result
            .map((value) => Module.fromJson(value, value['id'] as String))
            .toList();
      }
      return List.empty();
    } catch (e) {
      return handleException(e as PlatformException);
    }
  }

  void deleteCourseModules(String courseId) {
    BaseService.supabaseDataService
        .fetchAllWithQuery('modules', where: {'course_id': courseId})
        .asStream()
        .listen((snapshot) {
          snapshot.forEach((value) => deleteModule(value['id'] as String));
        });
  }
}
