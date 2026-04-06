import 'dart:io';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:filesize/filesize.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:video_compress/video_compress.dart';
import '../../common/model/base_model.dart';
import 'package:path/path.dart' as p;

class LessonViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LessonService _lessonService = locator<LessonService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  late Lesson _edittingLesson;

  late File _lessonDetailDocument;

  late File _lessonVideoFile;

  File get lessonDetailDocument => _lessonDetailDocument;
  File get lessonVideoFile => _lessonVideoFile;

  bool get isEditting => _edittingLesson != null;
  Module _module;
  Module get module => _module;
  Course _course;
  final MediaSelector _mediaSelector = locator<MediaSelector>();

  LessonViewModel(this._course, this._module);
  void setLessonDetailDocument(File doc) {
    this._lessonDetailDocument = doc;
    notifyListeners();
  }

  void setLessonVideoFile(File v) {
    this._lessonVideoFile = v;
    notifyListeners();
  }

  Future selectLessonDocument() async {
    var tempdoc = await _mediaSelector.selectDocument();
    if (tempdoc != null) {
      _lessonDetailDocument = File(tempdoc.files.single.path!);
      notifyListeners();
    }
    return _lessonDetailDocument;
  }

  Future selectLessonVideo() async {
    var tempdoc = await _mediaSelector.selectVideo();
    if (tempdoc != null) {
      _lessonVideoFile = File(tempdoc.files.single.path!);
      notifyListeners();
    }
    return _lessonVideoFile;
  }

  Future save(
      {required String moduleId,
      required String title,
      required String instructorNotes,
      String? moduleTitle,
      String? courseTitle,
      String? instructorName,
      String? bacgroundImage,
      bool? freeTrial,
      InstructionDoc? instructionDoc,
      VideoInfo? videoInfo}) async {
    setBusy(true);

    Lesson lesson = Lesson(
      businessId: module.businessId,
      courseId: module.courseId,
      moduleId: module.id,
      moduleTitle: moduleTitle!,
      courseTitle: courseTitle!,
      instructorName: instructorName!,
      title: title,
      freeTrial: freeTrial!,
      locked: freeTrial == true ? true : (isEditting ? _edittingLesson.locked : true),
      instructorNotes: instructorNotes,
      instructionDoc: instructionDoc!,
      videoInfo: videoInfo!,
    );
    var result;
    if (!isEditting) {
      result = await _lessonService.addLesson(lesson);
      lesson.id = result.id;
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      lesson.id = _edittingLesson.id;
      await _lessonService.updateLesson(_edittingLesson.id!, lesson);
    }
    //upload  to firestore
    CloudStorageResult lessonDocResult;

    lessonDocResult = await _cloudStorageService.uploadFile(
      fileToUpload: _lessonDetailDocument,
      title: super.currentBusiness.id! +
          "/" +
          module.id +
          "/" +
          (isEditting ? _edittingLesson.id : result.userId) +
          "/" +
          p.basename(_lessonDetailDocument.path),
    );
      //update course

    lesson.instructionDoc = new InstructionDoc(
        title: p.basename(_lessonDetailDocument.path),
        docUrl: lessonDocResult.mediaUrl,
        docSize: lessonDocResult.size);
    
    await handleVideoUpload(_lessonVideoFile, result, lesson);
    /*
    if (videoResult != null) {
      course.courseVideo = new VideoInfo(
        title: "Course Intro video",
        videoUrl: videoResult.mediaUrl,
        videoSize: videoResult.size,
      );
      if (videoThumbnailResult != null) {
        course.courseVideo.thumbUrl = videoThumbnailResult.mediaUrl;
      }
    } else if (edittingCourse && course.courseDetailDoc != null) {
      course.courseVideo.videoSize = _edittingCourse.courseVideo.videoSize;
      course.courseVideo.videoUrl = _edittingCourse.courseVideo.videoUrl;
    }
    //update collection
    if (!isEditting) {
      await _lessonService.updateLesson(result.documentID, course);
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      await _lessonService.updateLesson(_edittingLesson.documentId, course);
    }*/

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create Lesson',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Successful!',
        description: 'Your Lesson has been created',
      );
    }

    _navigationService.pop();
  }

  Future handleVideoUpload(File videoFile, var result, Lesson lesson) async {
    MediaUploadService mediaService = MediaUploadService();

    //create thumbnail
    File thumbnailFile =
        await mediaService.getVideoThumbnail(videoFile.path, 30);
    //upload thumbnail
    CloudStorageResult videoThumbnailResult =
        await _cloudStorageService.uploadFile(
      fileToUpload: thumbnailFile,
      title: super.currentBusiness.id! +
          "/" +
          lesson.courseId! +
          "/" +
          lesson.moduleId! +
          "/" +
          (isEditting ? _edittingLesson.id! : result.userId) +
          "/" +
          p.basename(thumbnailFile.path),
    );
    lesson.videoInfo!.thumbUrl = videoThumbnailResult.mediaUrl;
  
    //update Media Info
    MediaInfo mediaInfo = await mediaService.getMediaInfo(videoFile.path);
    lesson.videoInfo!.videoSize = filesize(mediaInfo.filesize);
    lesson.videoInfo!.title =
        mediaInfo.title != null && mediaInfo.title!.length > 0
            ? mediaInfo.title!
            : p.basename(mediaInfo.path!);
    lesson.videoInfo!.duration = computeDuration(mediaInfo.duration.toString());
    lesson.videoInfo!.rawVideoPath = mediaInfo.path!;
    String uploadPath = super.currentBusiness.id! +
        "/" +
        lesson.courseId! +
        "/" +
        lesson.moduleId! +
        "/" +
        (isEditting ? _edittingLesson.id! : result.userId);
    //compress video
    mediaService.uploadVideo(lesson.videoInfo!, uploadPath,
        onComplete: () async {
      String downloadURL = uploadPath + '/' + lesson.videoInfo!.title!;
      lesson.videoInfo!.videoUrl = downloadURL;
      _lessonService.updateLesson(lesson.id!, lesson);
    });
    //update videoInfo
    /* await mediaService.compressVideo(path: videoFile.path);
    //upload video
    if (videoFile != null) {
      CloudStorageResult videofileResult =
          await _cloudStorageService.uploadFile(
        fileToUpload: videoFile,
        title: uploadPath,
      );
      course.videoInfo.videoUrl = videofileResult.mediaUrl;
    }*/

    //mediaService.uploadVideo(mediaInfo.file, uri + "?auth=" + userAuthToken);
  }

  void setEditingLesson(Lesson editingLesson) {
    _edittingLesson = editingLesson;
  }
}
