import 'package:intl/intl.dart';

class BusinessInvoice {
  String businessId;
  DateTime invoiceDate;
  double invoiceAmount;
  String currancyCode;
  DateTime startDate;
  DateTime endDate;
  DateTime dueDate;
  DateTime paidDate;
  String paidBy;
  String paidVia;
  String createdTimestamp;
  String updatedTimestamp;
  String modifiedBy;
  List<BillingItem> billingItems;
  String documentId;
    BusinessInvoice({
      required this.businessId,
      required this.invoiceDate,
      required this.invoiceAmount,
      required this.currancyCode,
      required this.startDate,
      required this.endDate,
      required this.dueDate,
      required this.paidDate,
      required this.paidBy,
      required this.paidVia,
      required this.createdTimestamp,
      required this.updatedTimestamp,
      required this.modifiedBy,
      required this.billingItems,
      this.documentId = '',
    });

  BusinessInvoice.fromJson(String docId, Map<String, dynamic> json)
      : documentId = docId,
        businessId = json['business_id'],
        invoiceDate = DateFormat.yMMMMd().parse(json['invoice_date']),
        invoiceAmount = json['Invoice_amount'],
        currancyCode = json['currancy_code'],
        startDate = DateFormat.yMMMMd().parse(json['start_date']),
        endDate = DateFormat.yMMMMd().parse(json['end_date']),
        dueDate = DateFormat.yMMMMd().parse(json['due_date']),
        paidDate = DateFormat.yMMMMd().parse(json['paid_date']),
        paidBy = json['paid_by'],
        paidVia = json['paid_via'],
        createdTimestamp = json['created_timestamp'],
        updatedTimestamp = json['updated_timestamp'],
        modifiedBy = json['modified_by'] ?? json['modif_by'] ?? '',
        billingItems = json['billing_items'] != null
            ? List<BillingItem>.from(
                (json['billing_items'] as List).map((v) => BillingItem.fromJson(v)))
            : <BillingItem>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['invoice_date'] = DateFormat.yMMMMd().format(this.invoiceDate);
    data['Invoice_amount'] = this.invoiceAmount;
    data['currancy_code'] = this.currancyCode;
    data['start_date'] = DateFormat.yMMMMd().format(this.startDate);
    data['end_date'] = DateFormat.yMMMMd().format(this.endDate);
    data['due_date'] = DateFormat.yMMMMd().format(this.dueDate);
    data['paid_date'] = DateFormat.yMMMMd().format(this.paidDate);
    data['paid_by'] = this.paidBy;
    data['paid_via'] = this.paidVia;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['modified_by'] = this.modifiedBy;
    data['billing_items'] = this.billingItems.map((v) => v.toJson()).toList();
      return data;
  }
}

class BillingItem {
  String itemType;
  String description;
  int quantity;
  double rate;
  double amount;
  String createdTimestamp;
  String updatedTimestamp;
  String modifyBy;

  String documentId;

  BillingItem({
    required this.itemType,
    required this.description,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.createdTimestamp,
    required this.updatedTimestamp,
    required this.modifyBy,
    this.documentId = '',
  });

  BillingItem.fromJson(Map<String, dynamic> json)
      : itemType = json['item_type'],
        description = json['description'],
        quantity = json['quantity'],
        rate = json['rate'],
        amount = json['amount'],
        createdTimestamp = json['created_timestamp'],
        updatedTimestamp = json['updated_timestamp'],
        modifyBy = json['modify_by'],
        documentId = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_type'] = this.itemType;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['modify_by'] = this.modifyBy;
    return data;
  }
}
