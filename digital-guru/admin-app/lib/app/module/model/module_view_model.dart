import 'dart:io';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:filesize/filesize.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

class ModuleViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ModuleService _moduleService = locator<ModuleService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final MediaSelector _mediaSelector = locator<MediaSelector>();

  late File _backgroundImage, _moduleDetailDocument, _moduleVideo;

  File get backgroundImage => _backgroundImage;
  File get moduleDetailDocument => _moduleDetailDocument;
  File get moduleVideo => _moduleVideo;

  late Module _edittingModule;
  // ignore: unnecessary_null_comparison
  bool get _editting => _edittingModule != null;

  Course course;

  ModuleViewModel(this.course);

  void setBackgroundImage(File image) {
    this._backgroundImage = image;
    notifyListeners();
  }

  void setModuleDetailDocument(File doc) {
    this._moduleDetailDocument = doc;
    notifyListeners();
  }

  void setModuleVideo(File v) {
    this._moduleVideo = v;
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

  Future selectModuleDocument() async {
    var tempdoc = await _mediaSelector.selectDocument();
    if (tempdoc != null) {
      _moduleDetailDocument = File(tempdoc.files.single.path ?? '');
      notifyListeners();
    }
    return _moduleDetailDocument;
  }

  Future selectModuleVideo() async {
    var tempdoc = await _mediaSelector.selectVideo();
    if (tempdoc != null) {
      _moduleVideo = File(tempdoc.files.single.path ?? '');
      notifyListeners();
    }
    return _moduleVideo;
  }

  List<String> populateTags(String data) {
    if (data.length > 0) {
      List<String> t = data.split(',');
      List<String> tags = t;
      if (t.length > 6) {
        tags = t.sublist(0, 6);
        return tags;
      } else {
        int diff = 6 - t.length;
        switch (diff) {
          case 1:
            tags.add("value 6");
            break;
          case 2:
            tags.add("values 5");
            tags.add("values 6");
            break;
          case 3:
            tags.add("values 4");
            tags.add("values 5");
            tags.add("values 6");
            break;
          case 4:
            tags.add("values 3");
            tags.add("values 4");
            tags.add("values 5");
            tags.add("values 6");
            break;
          case 5:
            tags.add("values 2");
            tags.add("values 3");
            tags.add("values 4");
            tags.add("values 5");
            tags.add("values 6");
            break;
        }
        return tags;
      }
    } else {
      return ["tag 1", "tag 2", "tag 3", " tag 4", "tag 5", "tag 6"];
    }
    // return List<String>.empty(growable: true);
  }

  Future save(
      {required String courseId,
      String? businessId,
      required String title,
      String? moduleName,
      double? purchaseAmount,
      int? discountPercentage,
      bool? published,
      String? tagData,
      List<PricePlan>? pricePlan,
      ModuleBackground? background,
      ModuleDetailDoc? moduleDetailDoc,
      VideoInfo? moduleVideo}) async {
    setBusy(true);

    var result;
    Module module = Module(
        courseId: course.id ?? '',
        businessId: currentBusiness.id ?? '',
        name: moduleName ?? '',
        title: title,
        purchaseAmount: purchaseAmount ?? 0.0,
        lessonCount: 0,
        discountPercentage: discountPercentage ?? 0,
        published: published ?? false,
        tags: populateTags(tagData!),
        pricePlan: pricePlan ?? [],
        moduleBackground: background ?? ModuleBackground(),
        moduleDetailDoc: moduleDetailDoc ?? ModuleDetailDoc(),
        moduleVideo: moduleVideo ?? VideoInfo());
    if (!_editting) {
      result = await _moduleService.addModule(module);
      module.id = result.userId;
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      module.id = _edittingModule.id;
      await _moduleService.updateModule(_edittingModule.id, module);
    }
    CloudStorageResult? backgroundResult, documentDetailResult;

    if (_backgroundImage != null) {
      backgroundResult = await _cloudStorageService.uploadFile(
        fileToUpload: _backgroundImage,
        title: super.currentBusiness.id! +
            "/" +
            courseId +
            "/" +
            (_editting ? _edittingModule.id : result.userId) +
            "/" +
            p.basename(_backgroundImage.path),
      );
    }
    if (_moduleDetailDocument != null) {
      documentDetailResult = await _cloudStorageService.uploadFile(
        fileToUpload: _moduleDetailDocument,
        title: super.currentBusiness.id! +
            "/" +
            (_editting ? _edittingModule.id : result.userId) +
            "/" +
            p.basename(_moduleDetailDocument.path),
      );
    }

//update module
    if (backgroundResult != null) {
      module.moduleBackground = new ModuleBackground(
          title: "background",
          imageUrl: backgroundResult.mediaUrl,
          imageSize: backgroundResult.size);
    } else if (_editting && module.moduleBackground != null) {
      module.moduleBackground!.imageUrl =
          _edittingModule.moduleBackground!.imageUrl;
      module.moduleBackground!.imageSize =
          _edittingModule.moduleBackground!.imageSize;
    }
    if (documentDetailResult != null) {
      module.moduleDetailDoc = new ModuleDetailDoc(
          title: "Module Document",
          docUrl: documentDetailResult.mediaUrl,
          docSize: documentDetailResult.size);
    } else if (_editting && course.courseDetailDoc != null) {
      module.moduleDetailDoc!.docSize =
          _edittingModule.moduleDetailDoc!.docSize;
      module.moduleDetailDoc!.docUrl = _edittingModule.moduleDetailDoc!.docUrl;
    }
    await handleVideoUpload(_moduleVideo, module);

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Failed!',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Success!',
        description: _editting
            ? 'Module Successfully updated.'
            : 'Module Successfully added.',
      );
    }
    _navigationService.pop();
  }

  Future handleVideoUpload(File videoFile, Module module) async {
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
          title: super.currentBusiness.id! +
              "/" +
              module.courseId +
              "/" +
              module.id +
              "/" +
              p.basename(thumbnailFile.path),
        );
        module.moduleVideo!.thumbUrl = videoThumbnailResult.mediaUrl;
      }

      //compress video
      MediaInfo mediaInfo = await mediaService.getMediaInfo(videoFile.path);
      module.moduleVideo!.videoSize = filesize(mediaInfo.filesize);
      module.moduleVideo!.title = mediaInfo.title!;
      module.moduleVideo!.duration =
          computeDuration(mediaInfo.duration.toString());
      module.moduleVideo!.rawVideoPath = mediaInfo.path!;

      //upload video
      /* CloudStorageResult videofileResult =
          await _cloudStorageService.uploadFile(
        fileToUpload: videoFile,
        title: super.currentBusiness.documentId! +
            "/" +
            module.documentId +
            "/" +
            p.basename(videoFile.path),
      );*/
      String uploadPath = super.currentBusiness.id! +
          "/" +
          module.courseId +
          "/" +
          module.id +
          "/";
      mediaService.uploadVideoWithProgress(
          onComplete: () async {
        String downloadURL = uploadPath + '/' + module.moduleVideo!.title!;
        module.moduleVideo!.videoUrl = downloadURL;
        // module.moduleVideo.videoUrl = videofileResult.mediaUrl;
        _moduleService.updateModule(module.id, module);
      }, videoInfo: module.moduleVideo!, uploadDir: uploadPath);

      //mediaService.uploadVideo(mediaInfo.file, uri + "?auth=" + userAuthToken);
    }
  }

  void setEditingModule(Module editingModule) {
    _edittingModule = editingModule;
  }

  void cancel() {
    _navigationService.pop();
  }
}
