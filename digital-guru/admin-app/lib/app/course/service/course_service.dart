import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CourseService extends BaseService {
  final CollectionReference _courseCollectionReference =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _lessonCollectionReference =
      FirebaseFirestore.instance.collection('lessons');

  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
  final BusinessService _businessService = locator<BusinessService>();

  final StreamController<List<Course>> _courseController =
      StreamController<List<Course>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Course>> _allPagedResults = List.empty(growable: true);

  static const int CoursesLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future getCourse(String documentId) async {
    try {
      var userData = await _courseCollectionReference.doc(documentId).get();
      return new Course.fromJson(userData.data(), documentId);
    } catch (e) {
      return handleException(e);
    }
  }

  Future addCourse(Course course) async {
    try {
      super.populateCommonFields(object: course, created: true);
      //update business lesson count
      BusinessProfile profile =
          await _businessService.getBusinessProfile(course.businessId);
      profile.publication.courseCounts = profile.publication.courseCounts + 1;
      DocumentReference bpRef =
          _businessProfileCollectionReference.doc(profile.documentId);

      await _businessService.updateBusinessProfileStats(profile);

      return await _courseCollectionReference.add(course.toJson());
    } catch (e) {
      return handleException(e);
    }
  }

  Future getBusinessCourses(String businessId) async {
    try {
      var courseDocumentSnapshot = await _courseCollectionReference
          .where("business_id", isEqualTo: businessId)
          .orderBy('display_order')
          .get();
      if (courseDocumentSnapshot.docs.isNotEmpty) {
        return courseDocumentSnapshot.docs
            .map((snapshot) => Course.fromJson(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      return handleException(e);
    }
  }

  Stream listenToCourseesRealTime(String businessId) {
    // Register the handler for when the posts data changes
    _requestCoursees(businessId);
    return _courseController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestCoursees(String businessId) {
    // #2: split the query from the actual subscription
    Query pageCourseesQuery;
    if (businessId != null) {
      pageCourseesQuery = _courseCollectionReference
          .where("business_id", isEqualTo: businessId)
          .orderBy('display_order');
    } else {
      pageCourseesQuery = _courseCollectionReference.orderBy('title');
    }
    pageCourseesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var courses = snapshot.docs
            .map((snapshot) => Course.fromJson(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
        _courseController.add(courses);
      }
    });
  }

  Future deleteCourse({@required Course course}) async {
    super.populateCommonFields(object: course, deleted: true);
    await _courseCollectionReference.doc(course.documentId).delete();
  }

  Future updateCourse(String courseId, Course course) async {
    try {
      super.populateCommonFields(object: course, created: false);
      await _courseCollectionReference.doc(courseId).update(course.toJson());
    } catch (e) {
      return handleException(e);
    }
  }

  void requestMoreData(String businessId) => _requestCoursees(businessId);

  Future countLessonCount(Course c) async {
    try {
      int count = 0;
      _lessonCollectionReference
          .where("course_id", isEqualTo: c.documentId)
          .get()
          .then((snap) => {count = snap.docs.length});
      return count;
    } catch (e) {
      return handleException(e);
    }
  }

  Future<int> courseCount() async {
    int count = 0;
    await _courseCollectionReference
        .where("deleted", isNotEqualTo: true)
        .get()
        .then((snap) => {count = snap.docs.length});
    return count;
  }
}
