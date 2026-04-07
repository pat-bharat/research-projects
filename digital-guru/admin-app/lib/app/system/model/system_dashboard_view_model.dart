import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/billing/service/business_billing_service.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/model/system_profile.dart';
import 'package:digiguru/app/system/service/system_service.dart';
import 'package:digiguru/app/user/model/user.dart';

import '../../common/model/base_model.dart';

class SystemDashBoardViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  //final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final SystemService _systemService = locator<SystemService>();
  final BusinessBillingService _businessBillingService =
      locator<BusinessBillingService>();
  final CloudStorageService _cloudStoreService = locator<CloudStorageService>();
  late List<BusinessInvoice> _businessInvoices;

  Future<List<User>> getBusinessUsers(String businessId) async {
    return [];
  }

  Future getBusinessSettings(String businessId) async {
    return await _systemService.getBusinessSettings(businessId);
  }

  Future getAllSystemLegals(bool isBusinessnly) async {
    final SystemService _systemService = locator<SystemService>();
    List<SystemLegal> _legalList = List.empty(growable: true);
    if (isBusinessnly) {
      await _systemService.getBusinessOnlyLegals().then((legals) {
        _legalList.addAll(legals);
      });
    } else {
      await _systemService.getConsumerOnlyLegals().then((legals) {
        _legalList.addAll(legals);
      });
    }
    return _legalList;
  }

  Future deleteSystemLegal(SystemLegal businessLegal) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the SystemLegal?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed!) {
      setBusy(true);
      try {
        await _systemService.deleteSystemLegal(businessLegal);
        // Delete the image after the post is deleted
        await _cloudStoreService.deleteFile(businessLegal.pdfDoc!);
      } catch (e) {
        await _dialogService.showDialog(
            title: "Failed Todelete SystemLegal", description: e.toString());
      }

      setBusy(false);
    }
  }

  void listenToBusinessInvoices() async {
    setBusy(true);
    _businessBillingService
        .listenToInvoiceesRealTime(currentBusiness.id!)
        .listen((invoices) {
      List<BusinessInvoice> bInvoices = invoices;
      if (bInvoices.isNotEmpty) {
        _businessInvoices = bInvoices;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future getAllBusinesses() async {
    setBusy(true);
    List<Business> list = await _systemService.getAllBusinessesList();
    notifyListeners();
    setBusy(false);
    return list;
  }

  void editBusiness() {
    _navigationService.navigateTo(CreateBusinessViewRoute,
        arguments: currentBusiness);
  }

  Future getSystemProfile() async {
    setBusy(true);
    late SystemProfile profile;
    await _systemService.getSystemProfile().then((value) => profile = value);
    notifyListeners();
    setBusy(false);
    return profile;
  }

  Future getBusinessProfile(String bid) async {
    late BusinessProfile businessProfile;
    setBusy(true);
    await _systemService
        .getBusinessProfile(bid)
        .then((value) => businessProfile = value);
    notifyListeners();
    setBusy(false);
    return businessProfile;
  }

  void updateSystemLegal(SystemLegal legal) {}

  void updateSystemBusinessSetting(BusinessSetting businessSetting) async {
    await _systemService.updateBusinessSettings(businessSetting);
  }
}
