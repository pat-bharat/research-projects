import 'dart:io';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:filesize/filesize.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

class ModuleViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ModuleService _moduleService = locator<ModuleService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final MediaSelector _mediaSelector = locator<MediaSelector>();

  File _backgroundImage, _moduleDetailDocument, _moduleVideo;

  File get backgroundImage => _backgroundImage;
  File get moduleDetailDocument => _moduleDetailDocument;
  File get moduleVideo => _moduleVideo;

  Module _edittingModule;
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
      _moduleDetailDocument = File(tempdoc.files.single.path);
      notifyListeners();
    }
    return _moduleDetailDocument;
  }

  Future selectModuleVideo() async {
    var tempdoc = await _mediaSelector.selectVideo();
    if (tempdoc != null) {
      _moduleVideo = File(tempdoc.files.single.path);
      notifyListeners();
    }
    return _moduleVideo;
  }

  List<String> populateTags(String data) {
    if (data != null && data.length > 0) {
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
      {@required String courseId,
      String businessId,
      @required String title,
      name,
      double purchaseAmount,
      int discountPercentage,
      bool published,
      String tagData,
      List<PricePlan> pricePlan,
      ModuleBackground background,
      ModuleDetailDoc moduleDetailDoc,
      VideoInfo moduleVideo}) async {
    setBusy(true);

    var result;
    Module module = Module(
        courseId: course.documentId,
        businessId: currentBusiness.documentId,
        name: name,
        title: title,
        purchaseAmount: purchaseAmount,
        lessonCount: 0,
        discountPercentage: discountPercentage,
        published: published,
        tags: populateTags(tagData),
        pricePlan: pricePlan,
        moduleBackground: background,
        moduleDetailDoc: moduleDetailDoc,
        moduleVideo: moduleVideo);
    if (!_editting) {
      result = await _moduleService.addModule(module);
      module.documentId = result.userId;
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      module.documentId = _edittingModule.documentId;
      await _moduleService.updateModule(_edittingModule.documentId, module);
    }
    CloudStorageResult backgroundResult, documentDetailResult, vodeoResult;

    if (_backgroundImage != null) {
      backgroundResult = await _cloudStorageService.uploadFile(
        fileToUpload: _backgroundImage,
        title: super.currentBusiness.documentId +
            "/" +
            courseId +
            "/" +
            (_editting ? _edittingModule.documentId : result.userId) +
            "/" +
            p.basename(_backgroundImage.path),
      );
    }
    if (_moduleDetailDocument != null) {
      documentDetailResult = await _cloudStorageService.uploadFile(
        fileToUpload: _moduleDetailDocument,
        title: super.currentBusiness.documentId +
            "/" +
            (_editting ? _edittingModule.documentId : result.userId) +
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
      module.moduleBackground.imageUrl =
          _edittingModule.moduleBackground.imageUrl;
      module.moduleBackground.imageSize =
          _edittingModule.moduleBackground.imageSize;
    }
    if (documentDetailResult != null) {
      module.moduleDetailDoc = new ModuleDetailDoc(
          title: "Module Document",
          docUrl: documentDetailResult.mediaUrl,
          docSize: documentDetailResult.size);
    } else if (_editting && course.courseDetailDoc != null) {
      module.moduleDetailDoc.docSize = _edittingModule.moduleDetailDoc.docSize;
      module.moduleDetailDoc.docUrl = _edittingModule.moduleDetailDoc.docUrl;
    }
    if (_moduleVideo != null) {
      await handleVideoUpload(_moduleVideo, module);
    } else {
      result = await _moduleService.updateModule(module.documentId, module);
    }

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
          title: super.currentBusiness.documentId +
              "/" +
              module.courseId +
              "/" +
              module.documentId +
              "/" +
              p.basename(thumbnailFile.path),
        );
        module.moduleVideo.thumbUrl = videoThumbnailResult.mediaUrl;
      }

      //compress video
      MediaInfo mediaInfo = await mediaService.getMediaInfo(videoFile.path);
      module.moduleVideo.videoSize = filesize(mediaInfo.filesize);
      module.moduleVideo.title = mediaInfo.title;
      module.moduleVideo.duration =
          computeDuration(mediaInfo.duration.toString());
      module.moduleVideo.rawVideoPath = mediaInfo.path;

      //upload video
      /* CloudStorageResult videofileResult =
          await _cloudStorageService.uploadFile(
        fileToUpload: videoFile,
        title: super.currentBusiness.documentId +
            "/" +
            module.documentId +
            "/" +
            p.basename(videoFile.path),
      );*/
      String uploadPath = super.currentBusiness.documentId +
          "/" +
          module.courseId +
          "/" +
          module.documentId +
          "/";
      mediaService.uploadVideo(module.moduleVideo, uploadPath,
          onComplete: () async {
        String downloadURL = await FirebaseStorage.instance
            .ref(uploadPath + '/' + module.moduleVideo.title)
            .getDownloadURL();
        module.moduleVideo.videoUrl = downloadURL;
        // module.moduleVideo.videoUrl = videofileResult.mediaUrl;
        _moduleService.updateModule(module.documentId, module);
      });

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
