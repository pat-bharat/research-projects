class BusinessLegal {
  String businessId;
  String title;
  String legalId;
  String pdfDoc;
  String legalType;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;

  String documentId;

  BusinessLegal(
      {this.businessId,
      this.title,
      this.legalId,
      this.pdfDoc,
      this.legalType,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  BusinessLegal.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    businessId = json['business_id'];
    title = json['title'];
    legalId = json['legal_id'];
    pdfDoc = json['pdf_doc'];
    legalType = json['legal_type'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['legal_id'] = this.legalId;
    data['pdf_doc'] = this.pdfDoc;
    data['legal_type'] = this.legalType;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
