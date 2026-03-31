import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/billing/service/business_billing_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataLoaderService extends BaseService {
  BusinessBillingService _businessInvoiceService =
      locator<BusinessBillingService>();
  loadBusinessInvoice() async {
    var binvoice = BusinessInvoice(
        businessId: BaseService.currentBusiness.documentId,
        createdTimestamp: DateTime.now().toIso8601String(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        dueDate: DateTime.now(),
        invoiceAmount: 100.00,
        invoiceDate: DateTime.now(),
        paidBy: "pat.bharat@gmail.com",
        paidDate: DateTime.now(),
        paidVia: "google Pay",
        billingItems: [
          BillingItem(
            amount: 30.00,
            itemType: BillingItemType.monthly,
            description: 'Setup Fees',
            quantity: 1,
            rate: 30.00,
          ),
          BillingItem(
            amount: 70.00,
            itemType: BillingItemType.setup,
            description: 'User fees',
            quantity: 7,
            rate: 10.00,
          ),
        ]);
    await _businessInvoiceService.addInvoice(binvoice);
  }

  void updateLessonsBusinessId(String bid) {
    final CollectionReference _lessonCollectionReference =
        FirebaseFirestore.instance.collection('lessons');
    _lessonCollectionReference.snapshots().forEach((element) {
      element.docs.forEach((element) {
        Lesson l = Lesson.fromJson(element.id, element.data());
        l.businessId = bid;
        _lessonCollectionReference.doc(element.id).update(l.toJson());
      });
    });
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FlutterDownloader.initialize(debug: true);
  Intl.defaultLocale = 'en_US';
  // Register all the models and services before the app starts
  await setupLocator();
  DataLoaderService service = DataLoaderService();
  service.updateLessonsBusinessId('oAq9WHcJ5DdTmwJZfjaq');
}
