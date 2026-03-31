import 'package:digiguru/app/common/model/base_model.dart';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/service/system_service.dart';

class BusinessSettingViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final SystemService _systemService = locator<SystemService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  static List<SystemLegal> _businessLegals;

  BusinessSetting _businessSetting;
  BusinessSetting get business => _businessSetting;

  BusinessSettingViewModel();

  Future deleteSystemLegal(SystemLegal businessLegal) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the SystemLegal?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      try {
        await _systemService.deleteSystemLegal(businessLegal);
        // Delete the image after the post is deleted
        await _cloudStorageService.deleteFile(businessLegal.pdfDoc);
      } catch (e) {
        await _dialogService.showDialog(
            title: "Failed Todelete SystemLegal", description: e.toString());
      }

      setBusy(false);
    }
  }

  Future update(BusinessSetting businessSetting) async {
    setBusy(true);
    try {
      await _systemService.updateBusinessSettings(businessSetting);
    } catch (e) {
      await _dialogService.showDialog(
          title: "Failed update Business settings", description: e.toString());
    }

    setBusy(false);
  }

/*
  void editInstructor(SystemLegal instructor) {
    // CourseModule cm CourseModule(course: _course, module: _modules[index])
    _navigationService.navigateTo(AddEditSystemLegalViewRoute,
        arguments: instructor);
  }
  */
  /*
  Future navigateToAddSystemLegalToBusiness() async {
    _navigationService.navigateTo(AddEditBusinessViewRoute);
  }
*/
  goBack() {
    _navigationService.pop();
  }

  Future getAllSystemLegals() {
    return _systemService.getBusinessOnlyLegals();
  }
}
