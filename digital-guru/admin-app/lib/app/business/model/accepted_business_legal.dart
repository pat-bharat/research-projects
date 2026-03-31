class AcceptedBusinessLegal {
  String businessId;
  String acceptedBy;
  String legalType;
  String pdfDoc;
  String acceptedTimestamp;

  AcceptedBusinessLegal(
      {this.businessId,
      this.acceptedBy,
      this.legalType,
      this.pdfDoc,
      this.acceptedTimestamp});

  AcceptedBusinessLegal.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    acceptedBy = json['accepted_by'];
    legalType = json['legal_type'];
    pdfDoc = json['pdf_doc'];
    acceptedTimestamp = json['accepted_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['accepted_by'] = this.acceptedBy;
    data['legal_type'] = this.legalType;
    data['pdf_doc'] = this.pdfDoc;
    data['accepted_timestamp'] = this.acceptedTimestamp;
    return data;
  }
}
