import 'dart:io';

import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;

class BusinessLegalListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final BusinessService _businessService = locator<BusinessService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final MediaSelector _mediaSelector = MediaSelector();

  static List<BusinessLegal> _businessLegals = [];

  //Business _business;
  //Business get business => _business;
  static List<BusinessLegal> get getBusinessLegals => _businessLegals;

  BusinessLegalListModel();
  void listenToBusinessLegals() async {
    setBusy(true);
    _businessService
        .listenToBusinessLegalRealTime(currentBusiness.documentId!)
        .listen((businessLegal) {
      List<BusinessLegal> businessLegals = businessLegal;
      if (businessLegals != null && businessLegals.length > 0) {
        _businessLegals = businessLegals;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future deleteBusinessLegal(BusinessLegal businessLegal) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the BusinessLegal?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed!) {
      setBusy(true);
      try {
        await _businessService.deleteBusinessLegal(businessLegal);
        // Delete the image after the post is deleted
        if (businessLegal.pdfDoc != null && businessLegal.pdfDoc!.isNotEmpty) {
          await _cloudStorageService.deleteFile(businessLegal.pdfDoc!);
        }
      } catch (e) {
        await _dialogService.showDialog(
            title: "Failed Todelete BusinessLegal", description: e.toString());
      }

      setBusy(false);
    }
  }

/*
  void editInstructor(BusinessLegal instructor) {
    // CourseModule cm CourseModule(course: _course, module: _modules[index])
    _navigationService.navigateTo(AddEditBusinessLegalViewRoute,
        arguments: instructor);
  }
  */
  /*
  Future navigateToAddBusinessLegalToBusiness() async {
    _navigationService.navigateTo(AddEditBusinessViewRoute);
  }
*/
  goBack() {
    _navigationService.pop();
  }

  Future getAllBusinessLegals() {
    return _businessService.getAllBusinessLegals(currentBusiness.documentId!);
  }

  Future updateBusinessLegal(BusinessLegal businessLegal) async {
    var tempdoc = await _mediaSelector.selectDocument();
    File? pdfFile;
    if (tempdoc != null) {
      // setState(() {
      pdfFile = File(tempdoc.files.single.path ?? '');
      //});
    }
    if (pdfFile != null) {
      //removeand add storagefile by default system legal file from system should be there
      try {
        if (businessLegal.pdfDoc != null && businessLegal.pdfDoc!.length > 0) {
          await _cloudStorageService.deleteFile(businessLegal.pdfDoc!);
        }
      } catch (e) {
        print("Failed to deletebusiness documen from Storage" + e.toString());
      }

      CloudStorageResult storageResult = await _cloudStorageService.uploadFile(
          fileToUpload: pdfFile,
          title:
              businessLegal.businessId + "/legals/" + p.basename(pdfFile.path));
      //nowupdate collection
      var colResult;
      if (storageResult != null) {
        businessLegal.pdfDoc = storageResult.mediaUrl;
        colResult = _businessService.updateBusinessLegal(
            businessLegal.documentId ?? '', businessLegal);
      }
      if (colResult != null && colResult is String) {
        await _dialogService.showDialog(
          title: 'Failed to Create Business',
          description: colResult,
        );
      } else {
        await _dialogService.showDialog(
          title: 'Success!',
          description: 'Your Business legal document is successfully updated',
        );
      }
    }

    return "Success";
  }
}

class BusinessBusinessLegalArgs {
  final Business business;
  final BusinessLegal businessLegal;
  BusinessBusinessLegalArgs({required this.business, required this.businessLegal});
}
