import 'dart:io';

import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/firebase_services/service/analytics_service.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/system/service/system_service.dart';
import 'package:digiguru/app/user/model/user.dart';
import 'package:flutter/foundation.dart';
import '../../common/model/base_model.dart';
import 'package:path/path.dart' as p;

class BusinessViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final BusinessService _businessService = locator<BusinessService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final MediaSelector _imageSelector = locator<MediaSelector>();
  final SystemService _systemService = locator<SystemService>();

  File? _logoImage;
  File? get logoImage => _logoImage;
  File? _bannerImage;
  File? get bannerImage => _bannerImage;

  late Business _edittingBusiness;

  bool get _editting => _edittingBusiness != null;

  Future selectLogoImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _logoImage = File(tempImage.path);
      notifyListeners();
    }
  }

  void setLogoImage(File file) {
    _logoImage = file;
  }

  void setBannerImage(File banner) {
    this._bannerImage = banner;
  }

  Future selectBannerImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _bannerImage = File(tempImage.path);
      notifyListeners();
    }
  }

  Future save({
    required String name,
    String? punchLine,
    String? description,
    required String email,
    required String phone,
    required String country,
    String? contactEmail,
    String? logoUrl,
    String? url,
  }) async {
    setBusy(true);

    CloudStorageResult? logoResult, bannerResult;

    var result;

    Business business = Business(
        name: name,
        punchLine: punchLine ?? '',
        country: country,
        emailId: email,
        contactEmail: contactEmail ?? '',
        url: url ?? '',
        mobilePhone: phone);
    // new business
    if (!_editting) {
      result = await _businessService.addBusiness(business);
      if (result is String) {
        await _dialogService.showDialog(
          title: 'Failed to Create Business',
          description: result,
          // add business legals
        );
        return;
      }
      business.documentId = result.userId;
      BaseService.currentBusiness = business;
    } else {
      business.documentId = _edittingBusiness.documentId;
      await _businessService.updateBusiness(
          _edittingBusiness.documentId!, business);
      BaseService.currentBusiness = business;
    }

    //now read business

    if (_logoImage != null) {
      logoResult = await _cloudStorageService.uploadFile(
        fileToUpload: _logoImage!,
        title: (_editting ? _edittingBusiness.documentId : result.userId) +
            "/" +
            p.basename(_logoImage!.path),
      );
      business.logoLink = logoResult.mediaUrl;
    }
    if (_bannerImage != null) {
      bannerResult = await _cloudStorageService.uploadFile(
        fileToUpload: _bannerImage!,
        title: (_editting ? _edittingBusiness.documentId : result.userId) +
            "/" +
            p.basename(_bannerImage!.path),
      );
      business.bannerLink = bannerResult.mediaUrl;
    }

    await _analyticsService.logCreated(
        name: "create_business", hasImage: _logoImage != null);

    if (logoResult != null || bannerResult != null) {
      _businessService.updateBusiness(
          _editting ? _edittingBusiness.documentId : result.userId, business);
      BaseService.currentBusiness = business;
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: _editting
            ? 'Failed to Update Business'
            : 'Failed to Create Business',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: _editting
            ? 'Business Sucessfully Updated'
            : 'Business Sucessfully Created',
        description: 'Your BUsiness has been created',
      );
    }

    _navigationService.navigateTo(CourseViewListRoute);
  }

  Future getSystemBusinessOnlyLegals() async {
    return await _systemService.getBusinessOnlyLegals();
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }

  void editBusiness() {
    _navigationService.navigateTo(CreateBusinessViewRoute,
        arguments: _edittingBusiness);
  }

  void setEditingBusiness(Business editingBusiness) {
    _edittingBusiness = editingBusiness;
  }

  void cancel() {
    _navigationService.pop();
  }

  void goBack() {
    _navigationService.pop();
  }

  void navigateToInstructors() {
    _navigationService.navigateTo(InstructorListViewRoute,
        arguments: _edittingBusiness);
  }

  void navigateToLegals() {
    _navigationService.navigateTo(BusinessLegalListViewRoute,
        arguments: _edittingBusiness);
  }
}
