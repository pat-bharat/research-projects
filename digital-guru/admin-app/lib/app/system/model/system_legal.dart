class SystemLegal {
  String title;
  String pdfDoc;
  bool active;
  String userType;
  String legalType;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  String documentId;
  SystemLegal(
      {this.title,
      this.pdfDoc,
      this.active,
      this.legalType,
      this.userType,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.documentId});

  SystemLegal.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    title = json['title'];
    pdfDoc = json['pdf_doc'];
    active = json['active'];
    userType = json['user_type'];
    legalType = json['legal_type'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['pdf_doc'] = this.pdfDoc;
    data['active'] = this.active;
    data['user_type'] = this.userType;
    data['legal_type'] = this.legalType;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
