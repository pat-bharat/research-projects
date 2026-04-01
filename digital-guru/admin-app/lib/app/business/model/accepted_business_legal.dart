class AcceptedBusinessLegal {
  late String businessId;
  late String acceptedBy;
  late String legalType;
  late String pdfDoc;
  late String acceptedTimestamp;

  AcceptedBusinessLegal(
      {required this.businessId,
      required this.acceptedBy,
      required this.legalType,
      required this.pdfDoc,
      required this.acceptedTimestamp});

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
