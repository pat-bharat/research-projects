import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/course/service/course_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:flutter/cupertino.dart';

class CourseListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final CourseService _courseService = locator<CourseService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  late List<Course> _courses;

  List<Course> get courses => _courses;

  void listenToCourses() {
    setBusy(true);
    String? businessId;
    if (currentBusiness != null) {
      businessId = currentBusiness!.id;
    }
    _courseService.listenToCourseesRealTime(businessId!).listen((coursessData) {
      List<Course> updatedCourses = coursessData;
      if (updatedCourses != null && updatedCourses.length > 0) {
        _courses = updatedCourses;
        notifyListeners();
        setBusy(false);
      }
    });

    
  }

  Future deleteCourse({required Course course}) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description:
          "Do you really want to delete course: " + course.title! + " ?",
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed == true) {
      //var courseToDelete = _courses[index];
      setBusy(true);
      await _courseService.deleteCourse(course: course);
      // Delete the image after the post is deleted
      if (course.background?.imageUrl != null) {
        await _cloudStorageService.deleteFile(course.background!.imageUrl!);
      }
      if (course.courseDetailDoc?.docUrl != null) {
        await _cloudStorageService.deleteFile(course.courseDetailDoc!.docUrl!);
      }

      if (course.courseVideo?.videoUrl != null) {
        await _cloudStorageService.deleteFile(course.courseVideo!.videoUrl!);
      }
      notifyListeners();
      setBusy(false);
    }
  }

  Future navigateToAddCourse() async {
    await _navigationService.navigateTo(CreateCourseViewRoute);
  }

  Future navigateToCreateBusinessView() async {
    await _navigationService.navigateTo(CreateBusinessViewRoute);
  }

  void editCourse(Course course) {
    _navigationService.navigateTo(CreateCourseViewRoute, arguments: course);
  }

  void editModules(Course course) {
    _navigationService.navigateTo(ModuleViewListRoute, arguments: course);
  }

  void requestMoreData() => _courseService.requestMoreData(
      currentBusiness.id!);

  Future saveCoursesDisplayOrder(List<Course> courses) async {
    bool result = false;
    for (final course in courses) {
      int index = courses.indexOf(course);
      if (index != course.displayOrder) {
        course.displayOrder = index;
        this._courseService.updateCourse(course.id!, course);
        result = true;
      }
    }
    if (result) {
      await _dialogService.showDialog(
        title: 'Success!',
        description: 'Successfully Updated Courses Order',
      );
    } else {
      await _dialogService.showDialog(
        title: 'Failure!',
        description: 'Failed to updated Courses Order',
      );
    }

    return result;
  }

  void navigateToBusiness() {
    _navigationService.navigateTo(CreateBusinessViewRoute,
        arguments: currentBusiness);
  }
/*
  int lessonCounts(Course c) {
    //setBusy(true);
    //Course c = _courses[index];
    int count = 0;
    if (c != null) {
      _courseService.countLessonCount(c).then((v) => {count = v});
    }
    //notifyListeners();
    //setBusy(false);
    return count;
  }*/
}
