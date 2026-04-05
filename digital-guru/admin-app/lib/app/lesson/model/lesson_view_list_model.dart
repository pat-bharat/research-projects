import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:flutter/cupertino.dart';

class LessonListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LessonService _lessonService = locator<LessonService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  List<Lesson> _lessons = List.empty(growable: true);

  late Module _module;
  late Course _course;
  Module get module => _module;
  Course get course => _course; 
  List<Lesson> get lessons => _lessons;

  LessonListModel({required Course course, required Module module}) {
    this._module = module;
    this._course = course;
  }

  void listenToLessons() async {
    setBusy(true);
    _lessonService.listenToLessonsRealTime(_module.documentId).listen((lesson) {
      List<Lesson> lessons = lesson;
      if (lessons != null && lessons.length > 0) {
        _lessons = lessons;
        //notifyListeners();
      }
      setBusy(false);
    });
  }

  Future deleteLesson(Lesson lesson) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the Lesson?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed!) {
      setBusy(true);
      await _lessonService.deleteLesson(lesson.documentId!);
      // Delete the image after the post is deleted
      await _cloudStorageService.deleteFile(lesson.videoInfo!.thumbUrl!);
      setBusy(false);
    }
  }

  void editLesson(Lesson lesson) {
    // CourseModule cm CourseModule(course: _course, module: _modules[index])
    _navigationService.navigateTo(CreateLessonViewRoute,
        arguments: new CourseModuleLessonsArgs(
            course: _course, module: _module, lesson: lesson));
  }

  void requestMoreData() => _lessonService.requestMoreData(_module.documentId);

  Future navigateToAddLessonToModule() async {
    _navigationService.navigateTo(CreateLessonViewRoute,
        arguments:
            new CourseModuleLessonsArgs(course: _course, module: _module));
  }

  void saveLessonDisplayOrder(List<Lesson> items) async {
    for (final item in items) {
      int index = items.indexOf(item);
      if (index != item.displayOrder) {
        item.displayOrder = index;
        this._lessonService.updateLesson(item.documentId!, item);
      }
    }
  }
}

class CourseModuleLessonsArgs {
  Course course;
  Module module;
  Lesson? lesson;

  CourseModuleLessonsArgs({required this.course, required this.module, this.lesson});
}
