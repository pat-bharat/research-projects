import 'dart:io';

import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/instructor/service/instructor_service.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:flutter/foundation.dart';
import '../../common/model/base_model.dart';
import 'package:path/path.dart' as p;

class InstructorViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final InstructorService _instructorService = locator<InstructorService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  Instructor _edittingInstructor;

  bool get isEditting => _edittingInstructor != null;
  Business _business;
  Business get business => _business;

  final MediaSelector _mediaSelector = locator<MediaSelector>();

  InstructorViewModel();

  File _profilePicFile;
  File get profilePicFile => _profilePicFile;

  Future selectProfilePicture() async {
    var tempdoc = await _mediaSelector.selectImage();
    if (tempdoc != null) {
      _profilePicFile = File(tempdoc.path);
      notifyListeners();
    }
    return _profilePicFile;
  }

  void setProfilePicture(File profilePic) {
    _profilePicFile = profilePic;
  }

  Future save(
      {@required String fullName,
      @required String email,
      @required mobileNumber,
      @required country,
      String url,
      introduction,
      profilePicture}) async {
    setBusy(true);

    Instructor course = Instructor(
        businessId: currentBusiness.documentId,
        introduction: introduction,
        fullName: fullName,
        mobileNumber: mobileNumber,
        country: country,
        url: url,
        email: email,
        profilePic: profilePicture);
    var result;
    if (!isEditting) {
      result = await _instructorService.addInstructor(course);
      course.documentId = result.userId;
      //await _analyticsService.logPostCreated(hasImage: _logoImage != null);
    } else {
      course.documentId = _edittingInstructor.documentId;
      await _instructorService.updateInstructor(
          _edittingInstructor.documentId, course);
    }
    CloudStorageResult profilePicResult;

    if (_profilePicFile != null) {
      profilePicResult = await _cloudStorageService.uploadFile(
        fileToUpload: _profilePicFile,
        title: super.currentBusiness.documentId +
            "/" +
            "instructors" +
            "/" +
            p.basename(_profilePicFile.path),
      );

      if (_profilePicFile != null) {
        course.profilePic = profilePicResult.mediaUrl;
        _instructorService.updateInstructor(course.documentId, course);
      }
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create Instructor',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Successful!',
        description: isEditting
            ? "Instructor is successfully updated"
            : "Instructor is successfully Created",
      );
    }

    _navigationService.pop();
  }

  goBack() {
    _navigationService.pop();
  }

  void setEditingInstructor(Instructor editingInstructor) {
    _edittingInstructor = editingInstructor;
  }

  void cancel() {
    _navigationService.pop();
  }
}
