import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/course/service/course_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:flutter/services.dart';

class LessonService extends BaseService {
  final CollectionReference _lessonCollectionReference =
      FirebaseFirestore.instance.collection('lessons');
  final ModuleService _moduleService = locator<ModuleService>();
  final CourseService _courseService = locator<CourseService>();
  final BusinessService _businessService = locator<BusinessService>();
  final CollectionReference _moduleCollectionReference =
      FirebaseFirestore.instance.collection('modules');
  final CollectionReference _courseCollectionReference =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
  final StreamController<List<Lesson>> _moduleController =
      StreamController<List<Lesson>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Lesson>> _allPagedResults = List.empty(growable: true);

  ModuleService _modeuleService = locator<ModuleService>();
  static const int LessonsLimit = 20;

  late DocumentSnapshot _lastDocument;
  bool _hasMoreLessons = true;

  Future getLesson(String lessonId) async {
    try {
      var userData = await _lessonCollectionReference.doc(lessonId).get();
      return new Lesson.fromJson(lessonId, userData.data() as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getAllBusinessFreeLessons() async {
    try {
      List<Lesson> lessons = new List.empty(growable: true);
      await _lessonCollectionReference
          .where("free_trial", isEqualTo: true)
          .orderBy("created_timestamp", descending: true)
          .get()
          .then((value) => {
                value.docs.forEach(
                    (c) => lessons.add(Lesson.fromJson(c.id, c.data() as Map<String, dynamic>)))
              });
      Map<String, bool> modules = {};
      await _modeuleService
          .getAllBusinessPublishedModules(
              BaseService.currentBusiness.documentId!)
          .then((mods) => mods.forEach((m) {
                modules.putIfAbsent(m.documentId, () => m.published);
              }));

      //TODO check if module for lesson is marked as published?
      List<Lesson> publishedLessons = new List.empty(growable: true);

      lessons.forEach((les) {
        if (modules.containsKey(les.moduleId)) {
          modules.forEach((key, pub) {
            if (key == les.moduleId) {
              if (pub == true) publishedLessons.add(les);
            }
          });
        }
      });
      return publishedLessons;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getAllFreeLessonsForCourse(String courseId) async {
    try {
      List<Lesson> lessons = new List.empty(growable: true);
      await _lessonCollectionReference
          .where("course_id", isEqualTo: courseId)
          .get()
          .then((value) => {
                value.docs.forEach(
                    (c) => lessons.add(Lesson.fromJson(c.id, c.data() as Map<String, dynamic>)))
              });
      return lessons;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getModuleLessons(String moduleId) async {
    try {
      List<Lesson> lessons = new List.empty(growable: true);
      await _lessonCollectionReference
          .where("module_id", isEqualTo: moduleId)
          .get()
          .then((value) => {
                value.docs.forEach(
                    (c) => lessons.add(Lesson.fromJson(c.id, c.data() as Map<String, dynamic>)))
              });
      return lessons;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future addLesson(Lesson lesson) async {
    try {
      populateCommonFields(object: lesson, created: true);
      //update module lesson count,

      var batch = FirebaseFirestore.instance.batch();
      Module mod = await _moduleService.getModule(lesson.moduleId!);
      mod.lessonCount = mod.lessonCount! + 1;
      DocumentReference mRef = _moduleCollectionReference.doc(mod.documentId);
      batch.update(mRef, mod.toJson());
//update Course Lesson count
      Course course = await _courseService.getCourse(lesson.courseId!);
      course.lessonCount = (course.lessonCount! + 1);
      DocumentReference cRef =
          _courseCollectionReference.doc(course.documentId);
      batch.update(cRef, course.toJson());
//update business lesson count
      BusinessProfile profile =
          await _businessService.getBusinessProfile(lesson.businessId!);
      profile.publication!.lessonCounts = (profile.publication!.lessonCounts) + 1;
      DocumentReference bpRef =
          _businessProfileCollectionReference.doc(profile.documentId);
      batch.update(bpRef, profile.toJson());

      DocumentReference ref =
          await _lessonCollectionReference.add(lesson.toJson());
      batch.commit();
      return ref;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getModulesOnceOff() async {
    try {
      var lessonDocumentSnapshot =
          await _lessonCollectionReference.limit(LessonsLimit).get();
      if (lessonDocumentSnapshot.docs.isNotEmpty) {
        return lessonDocumentSnapshot.docs
            .map((snapshot) => Module.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            // ignore: unnecessary_null_comparison
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Stream listenToLessonsRealTime(String moduleId) {
    // Register the handler for when the posts data changes
    _requestLessons(moduleId);
    return _moduleController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestLessons(String moduleId) {
    // #2: split the query from the actual subscription
    var pageModulesQuery = _lessonCollectionReference
        .where("module_id", isEqualTo: moduleId)
        .orderBy('display_order');
    // #3: Limit the amount of results
    //.limit(LessonsLimit);

    // #5: If we have a document start the query after it
    /* if (_lastDocument != null) {
      pageModulesQuery = pageModulesQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreLessons) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;
*/
    pageModulesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var modules = snapshot.docs
            .map((snapshot) => Lesson.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>))
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
        var allLessons = _allPagedResults.fold<List<Lesson>>(
            List<Lesson>.empty(growable: true),
            (initialValue, pageItems) => initialValue..addAll(pageItems));
*/
        // #12: Broadcase all posts
        _moduleController.add(modules);

        // #13: Save the last document from the results only if it's the current last page
        /* if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = snapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreLessons = modules.length == LessonsLimit;*/
      }
    });
  }

  Future deleteLesson(String lessonId) async {
    //decement lesson count from module, course and business profile.
    await _lessonCollectionReference.doc(lessonId).delete();
  }

  Future updateLesson(String lessonId, Lesson lesson) async {
    try {
      populateCommonFields(object: lesson);
      await _lessonCollectionReference.doc(lessonId).update(lesson.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  void requestMoreData(String moduleId) => _requestLessons(moduleId);
}
