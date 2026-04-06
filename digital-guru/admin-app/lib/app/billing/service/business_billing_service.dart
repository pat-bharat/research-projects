import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/shared_services/supabase_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BusinessBillingService extends BaseService {
  final supabaseDataService = SupabaseDataService();
  final StreamController<List<BusinessInvoice>> _invoiceController =
      StreamController<List<BusinessInvoice>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<BusinessInvoice>> _allPagedResults = List.empty(growable: true);

  static const int InvoiceLimit = 20;

  bool _hasMorePosts = true;

  Future getInvoice(String documentId) async {
    try {
      var userData = await supabaseDataService.fetchById('business_billing',documentId);
      return new BusinessInvoice.fromJson(documentId, userData as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future addInvoice(BusinessInvoice invoice) async {
    try {
      super.populateCommonFields(object: invoice, created: true);
      return await supabaseDataService.insert('business_billing', invoice.toJson());
    } catch (e) {
      return handleException(e as Exception);
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
    var invoices = supabaseDataService.fetchAllWithQuery("business_billing", where: {"business_id": businessId}, orderBy: "created_timestamp", ascending: false);
    

    invoices.asStream(). listen((invoices) {
      if (invoices.isNotEmpty) {
        var cources = invoices
            .map((invoice) =>
                BusinessInvoice.fromJson(invoice['id'], invoice))
            .toList();
        // #12: Broadcase all Invoice
        _invoiceController.add(cources);
      }
    });
  }

  Future updateInvoice(String invoiceId, BusinessInvoice invoice) async {
    try {
      super.populateCommonFields(object: invoice, created: false);
      await supabaseDataService.update('business_billing', invoiceId, invoice.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  void requestMoreData(String businessId) => _requestInvoices(businessId);
}
