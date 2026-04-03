class Invoice {
  String? businessId;
  String? invoiceDate;
  String? invoiceAmount;
  String? currancyCode;
  String? startDate;
  String? endDate;
  String? dueDate;
  String? paidDate;
  String? paidBy;
  String? paidVia;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifyBy;
  List<BillingItems>? billingItems;

  Invoice(
      {this.businessId,
      this.invoiceDate,
      this.invoiceAmount,
      this.currancyCode,
      this.startDate,
      this.endDate,
      this.dueDate,
      this.paidDate,
      this.paidBy,
      this.paidVia,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy,
      this.billingItems});

  Invoice.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    invoiceDate = json['invoice_date'];
    invoiceAmount = json['Invoice_amount'];
    currancyCode = json['currancy_code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    dueDate = json['due_date'];
    paidDate = json['paid_date'];
    paidBy = json['paid_by'];
    paidVia = json['paid_via'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifyBy = json['modify_by'];
    if (json['billing_items'] != null) {
      billingItems = <BillingItems>[];
      json['billing_items'].forEach((v) {
        billingItems!.add(BillingItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = this.businessId;
    data['invoice_date'] = this.invoiceDate;
    data['Invoice_amount'] = this.invoiceAmount;
    data['currancy_code'] = this.currancyCode;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['due_date'] = this.dueDate;
    data['paid_date'] = this.paidDate;
    data['paid_by'] = this.paidBy;
    data['paid_via'] = this.paidVia;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modify_by'] = this.modifyBy;
    if (this.billingItems != null) {
      data['billing_items'] = this.billingItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillingItems {
  String? itemType;
  String? description;
  String? quantity;
  String? rate;
  String? amount;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifyBy;

  BillingItems(
      {this.itemType,
      this.description,
      this.quantity,
      this.rate,
      this.amount,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  BillingItems.fromJson(Map<String, dynamic> json) {
    itemType = json['item_type'];
    description = json['description'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifyBy = json['modify_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_type'] = this.itemType;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modify_by'] = this.modifyBy;
    return data;
  }
}
