import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/billing/service/business_billing_service.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/shared_services/analytics_service.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/business/model/business_profille.dart';

class BusinessDashBoardViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final BusinessService _businessService = locator<BusinessService>();
  final BusinessBillingService _businessBillingService =
      locator<BusinessBillingService>();

  late List<BusinessInvoice> _businessInvoices;

  Future<List<BusinessLegal>> getConsumerLegals() async {
    return await _businessService
        .getAllBusinessLegals(currentBusiness.documentId!);
  }

  void listenToBusinessInvoices() async {
    setBusy(true);
    _businessBillingService
        .listenToInvoiceesRealTime(currentBusiness.documentId!)
        .listen((invoices) {
      List<BusinessInvoice> bInvoices = invoices;
      if (bInvoices != null && bInvoices.length > 0) {
        _businessInvoices = bInvoices;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future getBusinessProfile() async {
    BusinessProfile? profile;
    setBusy(true);
    profile = await _businessService
        .getBusinessProfile(currentBusiness.documentId!);
    // notifyListeners();
    setBusy(false);
    return profile;
  }

  void editBusiness() {
    _navigationService.navigateTo(CreateBusinessViewRoute,
        arguments: currentBusiness);
  }

  void editBusinessLegals() {
    _navigationService.navigateTo(BusinessLegalListViewRoute,
        arguments: currentBusiness);
  }
}
