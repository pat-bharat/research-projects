import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BusinessBillingService extends BaseService {
  final CollectionReference _invoiceCollectionReference =
      FirebaseFirestore.instance.collection('business_invoices');

  final StreamController<List<BusinessInvoice>> _invoiceController =
      StreamController<List<BusinessInvoice>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<BusinessInvoice>> _allPagedResults = List.empty(growable: true);

  static const int InvoiceLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future getInvoice(String documentId) async {
    try {
      var userData = await _invoiceCollectionReference.doc(documentId).get();
      return new BusinessInvoice.fromJson(documentId, userData.data());
    } catch (e) {
      return handleException(e);
    }
  }

  Future addInvoice(BusinessInvoice invoice) async {
    try {
      super.populateCommonFields(object: invoice, created: true);
      return await _invoiceCollectionReference.add(invoice.toJson());
    } catch (e) {
      return handleException(e);
    }
  }

  Stream listenToInvoiceesRealTime(String businessId) {
    // Register the handler for when the posts data changes
    _requestInvoices(businessId);
    return _invoiceController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestInvoices(String businessId) {
    // #2: split the query from the actual subscription
    var pageInvoiceQuery = _invoiceCollectionReference
        .where("business_id", isEqualTo: businessId)
        .orderBy('created_timestamp', descending: true)
        // #3: Limit the amount of results
        .limit(InvoiceLimit);

    pageInvoiceQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var cources = snapshot.docs
            .map((snapshot) =>
                BusinessInvoice.fromJson(snapshot.id, snapshot.data()))
            .toList();
        // #12: Broadcase all Invoice
        _invoiceController.add(cources);
      }
    });
  }

  Future updateInvoice(String invoiceId, BusinessInvoice invoice) async {
    try {
      super.populateCommonFields(object: invoice, created: false);
      await _invoiceCollectionReference.doc(invoiceId).update(invoice.toJson());
    } catch (e) {
      return handleException(e);
    }
  }

  void requestMoreData(String businessId) => _requestInvoices(businessId);
}
