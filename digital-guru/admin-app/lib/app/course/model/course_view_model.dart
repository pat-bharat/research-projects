import 'dart:io';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/course/service/course_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:filesize/filesize.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:video_compress/video_compress.dart';
import '../../common/model/base_model.dart';
import 'package:path/path.dart' as p;

class CourseViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final BusinessService _businessService = locator<BusinessService>();
  final CourseService _courseService = locator<CourseService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final MediaSelector _mediaSelector = locator<MediaSelector>();

  late File _backgroundImage, _syllabusDocument, _videoFile;

  File get videoFile => _videoFile;
  File get syllabusDocument => _syllabusDocument;
  File get backgroundImage => _backgroundImage;

  Course? _edittingCourse;

  bool get isEditingCourse => _edittingCourse != null;

  // List<CourseMedia> _medias;
  // List<CourseMedia> get medias => _medias;

  CourseViewModel() {
    // _medias = defaultMedias();
  }
  void setBannerImage(File image) {
    this._backgroundImage = image;
    notifyListeners();
  }

  void setSyllabusDocument(File doc) {
    this._syllabusDocument = doc;
    notifyListeners();
  }

  void setCourseVideo(File v) {
    this._videoFile = v;
    notifyListeners();
  }

  Future selectBannerImage() async {
    var tempImage = await _mediaSelector.selectImage();
    if (tempImage != null) {
      _backgroundImage = File(tempImage.path);
      notifyListeners();
    }
    return _backgroundImage;
  }

  Future selectCouseSyllabusImage() async {
    var tempdoc = await _mediaSelector.selectDocument();
    if (tempdoc != null && tempdoc.files.single.path != null) {
      _syllabusDocument = File(tempdoc.files.single.path!);
      notifyListeners();
    }
    return _syllabusDocument;
  }

  Future selectCourseVideo() async {
    var tempdoc = await _mediaSelector.selectVideo();
    if (tempdoc != null && tempdoc.files.single.path != null) {
      _videoFile = File(tempdoc.files.single.path!);
      notifyListeners();
    }
    return _videoFile;
  }

  Future save({
    required String title,
    required String description,
    required String instructorName,
    required String instructorEmail,
    required String language,
    required String instructorPhone,
    //String courseDetailDocPath,
    CourseBackground? background,
    CourseDetailDoc? courseDetailDoc,
    VideoInfo? courseVideo,
  }) async {
    setBusy(true);

    Course course = Course(
        businessId: super.currentBusiness.documentId!,
        title: title,
        description: description,
        language: language,
        instructorName: instructorName,
        instructorEmail: instructorEmail,
        instructorPhone: instructorPhone,
        background: background ?? CourseBackground(),
        courseDetailDoc: courseDetailDoc ?? CourseDetailDoc(),
        courseVideo: courseVideo ?? VideoInfo());
    course.displayOrder = isEditingCourse ? _edittingCourse!.displayOrder : 0;
    course.lessonCount = isEditingCourse ? _edittingCourse!.lessonCount : 0;
    var result;
    if (!isEditingCourse) {
      result = await _courseService.addCourse(course);
      course.documentId = result.userId;
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      course.documentId = _edittingCourse!.documentId!;
      await _courseService.updateCourse(_edittingCourse!.documentId!, course);
      course.documentId = _edittingCourse!.documentId!;
    }
    //upload  to firestore
    CloudStorageResult backgroundResult, syllabusResult;

    if (_backgroundImage != null) {
      backgroundResult = await _cloudStorageService.uploadFile(
        fileToUpload: _backgroundImage,
        title: super.currentBusiness.documentId! +
            "/" +
            (isEditingCourse ? _edittingCourse!.documentId! : result.userId) +
            "/" +
            p.basename(_backgroundImage.path),
      );
      if (backgroundResult != null) {
        course.background = new CourseBackground(
            title: "background",
            imageUrl: backgroundResult.mediaUrl,
            imageSize: backgroundResult.size);
      }
    }
    if (_syllabusDocument != null) {
      syllabusResult = await _cloudStorageService.uploadFile(
        fileToUpload: _syllabusDocument,
        title: super.currentBusiness.documentId! +
            "/" +
            (isEditingCourse ? _edittingCourse!.documentId : result.userId) +
            "/" +
            p.basename(_syllabusDocument.path),
      );
      if (syllabusResult != null) {
        course.courseDetailDoc = new CourseDetailDoc(
            title: p.basename(_syllabusDocument.path),
            docUrl: syllabusResult.mediaUrl,
            docSize: syllabusResult.size);
      }
    }
    if (_videoFile != null) {
      await handleVideoUpload(_videoFile, course);
    } else {
      result = await _courseService.updateCourse(course.documentId!, course);
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create Course',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Success!',
        description: isEditingCourse
            ? 'Your Course has been updated'
            : "Your Course has been created",
      );
    }

    _navigationService.pop();
  }

  Future handleVideoUpload(File videoFile, Course course) async {
    if (videoFile != null) {
      MediaUploadService mediaService = MediaUploadService();

      //create thumbnail
      File thumbnailFile =
          await mediaService.getVideoThumbnail(videoFile.path, 30);
      //upload thumbnail
      if (thumbnailFile != null) {
        CloudStorageResult videoThumbnailResult =
            await _cloudStorageService.uploadFile(
          fileToUpload: thumbnailFile,
          title: super.currentBusiness.documentId! +
              "/" +
              course.documentId! +
              "/" +
              p.basename(thumbnailFile.path),
        );
        course.courseVideo?.thumbUrl = videoThumbnailResult.mediaUrl;
      }

      //compress video
      MediaInfo mediaInfo = await mediaService.getMediaInfo(videoFile.path);
      course.courseVideo?.videoSize = filesize(mediaInfo.filesize);
      course.courseVideo?.title = mediaInfo.title!;
      course.courseVideo?.duration =
          computeDuration(mediaInfo.duration.toString());
      course.courseVideo?.rawVideoPath = mediaInfo.path!;

      //upload video
      /* CloudStorageResult videofileResult =
          await _cloudStorageService.uploadFile(
        fileToUpload: videoFile,
        title: super.currentBusiness.documentId +
            "/" +
            course.documentId! +
            "/" +
            p.basename(videoFile.path),
      );*/
      String uploadPath =
          super.currentBusiness.documentId! + "/" + course.documentId! + "/";

      mediaService.uploadVideo(course.courseVideo!, uploadPath,
          onComplete: () async {
        String downloadURL = await FirebaseStorage.instance
            .ref(uploadPath + '/' + course.courseVideo!.title)
            .getDownloadURL();
        course.courseVideo!.videoUrl = downloadURL;
        _courseService.updateCourse(course.documentId!, course);
      });
    }
  }

  Future<List<Instructor>> getInstructors() async {
    List<Instructor> list = List<Instructor>.empty(growable: true);
    await _businessService
        .getAllInstructors(currentBusiness.documentId!)
        .then((instructors) => {list.addAll(instructors)});
    return list;
  }

  void setEditingCourse(Course editingCourse) {
    _edittingCourse = editingCourse;
  }
}
