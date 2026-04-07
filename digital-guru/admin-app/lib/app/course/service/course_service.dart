import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/business/model/business_profille.dart';

class CourseService extends BaseService {
  //final CollectionReference _courseCollectionReference =
  //    FirebaseFirestore.instance.collection('courses');
  //final CollectionReference _lessonCollectionReference =
  //    FirebaseFirestore.instance.collection('lessons');

  //final CollectionReference _businessProfileCollectionReference =
  //    FirebaseFirestore.instance.collection('business_profile');
  final BusinessService _businessService = locator<BusinessService>();

  final StreamController<List<Course>> _courseController =
      StreamController<List<Course>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<Course>> _allPagedResults = List.empty(growable: true);

  static const int CoursesLimit = 20;

  //late DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future getCourse(String documentId) async {
    try {
      var userData = await BaseService.supabaseDataService
          .fetchById('courses', documentId);
      return new Course.fromJson(userData as Map<String, dynamic>, documentId);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future addCourse(Course course) async {
    try {
      super.populateCommonFields(object: course, created: true);
      //update business lesson count
      BusinessProfile profile =
          await _businessService.getBusinessProfile(course.businessId!);
      profile.publication!.courseCounts =
          (profile.publication!.courseCounts ?? 0) + 1;

      await _businessService.updateBusinessProfileStats(profile);

      return await BaseService.supabaseDataService
          .insert('courses', course.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessCourses(String businessId) async {
    try {
      var courseDocumentSnapshot = await BaseService.supabaseDataService
          .fetchAllWithQuery('courses',
              where: {'business_id': businessId}, orderBy: 'display_order');
      if (courseDocumentSnapshot.isNotEmpty) {
        return courseDocumentSnapshot
            .map((snapshot) =>
                Course.fromJson(snapshot, snapshot['id'] as String))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      return handleException(e as Exception);
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

    var pageCourseesQuery = BaseService.supabaseDataService.fetchAllWithQuery(
        'courses',
        where: {'business_id': businessId},
        orderBy: 'display_order');

    pageCourseesQuery.asStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        var courses = snapshot
            .map((snapshot) =>
                Course.fromJson(snapshot, snapshot['id'] as String))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
        _courseController.add(courses);
      }
    });
  }

  Future deleteCourse({required Course course}) async {
    super.populateCommonFields(object: course, deleted: true);
    await BaseService.supabaseDataService.delete('courses', course.id);
  }

  Future updateCourse(String courseId, Course course) async {
    try {
      super.populateCommonFields(object: course, created: false);
      await BaseService.supabaseDataService
          .update('courses', courseId, course.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  void requestMoreData(String businessId) => _requestCoursees(businessId);

  Future countLessonCount(Course c) async {
    try {
      int count = 0;
      BaseService.supabaseDataService
          .fetchAllWithQuery('lessons', where: {'course_id': c.id})
          .asStream()
          .listen((snap) {
            count = snap.length;
          });

      return count;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future<int> courseCount() async {
    int count = 0;
    await BaseService.supabaseDataService
        .fetchAllWithQuery('courses', where: {'deleted': false})
        .asStream()
        .listen((snap) {
          count = snap.length;
        });
    return count;
  }

  void deleteCourseById(String courseId) {
    BaseService.supabaseDataService.delete('courses', courseId);
  }
}
