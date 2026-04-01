class UserLegal {
  String? businessId;
  String? userId;
  String? title;
  String? legalId;
  String? pdfDoc;
  String? acceptedTimestamp;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;

  String? documentId;

  UserLegal(
      {required this.userId,
      required this.businessId,
      this.title,
      this.legalId,
      this.pdfDoc,
      this.acceptedTimestamp,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  UserLegal.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    userId = json['user_id'];
    businessId = json['business_id'];
    title = json['title'];
    legalId = json['legal_id'];
    pdfDoc = json['pdf_doc'];
    acceptedTimestamp = json['accepted_timestamp'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['legal_id'] = this.legalId;
    data['pdf_doc'] = this.pdfDoc;
    data['accepted_timestamp'] = this.createdTimestamp;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
