import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/billing/service/business_billing_service.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/course/model/course.dart';

class BusinessInvoiceListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final BusinessBillingService _businessBillinService =
      locator<BusinessBillingService>();
  late List<BusinessInvoice> _businessInvoice;

  List<BusinessInvoice> get businessInvoices => _businessInvoice;

  BusinessInvoiceListModel() {
    _businessInvoice = [];
  }
  void listenToBusinessInvoices() {
    setBusy(true);

    _businessBillinService
        .listenToInvoiceesRealTime(currentBusiness.id!)
        .listen((invocies) {
      List<BusinessInvoice> invoiceList = invocies;
      if (invoiceList.length > 0) {
        _businessInvoice = invoiceList;
      }
      notifyListeners();
      setBusy(false);
    });
  }

  Future navigateToAddCourse() async {
    await _navigationService.navigateTo(CreateCourseViewRoute);
  }

  Future navigateToCreateBusinessView() async {
    await _navigationService.navigateTo(CreateBusinessViewRoute);
  }

  void editCourse(Course course) {
    _navigationService.navigateTo(CreateCourseViewRoute, arguments: course);
  }

  void editModules(Course course) {
    _navigationService.navigateTo(ModuleViewListRoute, arguments: course);
  }

  void requestMoreData() =>
      _businessBillinService.requestMoreData(currentBusiness.id!);

  void navigateToBusiness() {
    _navigationService.navigateTo(CreateBusinessViewRoute,
        arguments: currentBusiness);
  }

  void gtAllBusinessInvoces() {}
}
