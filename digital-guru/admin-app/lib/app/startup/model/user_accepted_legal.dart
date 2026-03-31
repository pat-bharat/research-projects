class UserAcceptedLegal {
  String userId;
  String acceptedBy;
  String legalType;
  String pdfDoc;
  String acceptedTimestamp;

  UserAcceptedLegal(
      {this.userId,
      this.acceptedBy,
      this.legalType,
      this.pdfDoc,
      this.acceptedTimestamp});

  UserAcceptedLegal.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    acceptedBy = json['accepted_by'];
    legalType = json['legal_type'];
    pdfDoc = json['pdf_doc'];
    acceptedTimestamp = json['accepted_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['accepted_by'] = this.acceptedBy;
    data['legal_type'] = this.legalType;
    data['pdf_doc'] = this.pdfDoc;
    data['accepted_timestamp'] = this.acceptedTimestamp;
    return data;
  }
}
