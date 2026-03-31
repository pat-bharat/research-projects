class Billing {
  int id;
  int inviceId;
  String itemType;
  String description;
  int quantity;
  String rate;
  String amount;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifyBy;

  Billing(
      {this.id,
      this.inviceId,
      this.itemType,
      this.description,
      this.quantity,
      this.rate,
      this.amount,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  Billing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inviceId = json['invice_id'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invice_id'] = this.inviceId;
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
