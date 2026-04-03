class Business {
  String? name;
  String? punchLine;
  String? description;
  String? splashScreen;
  String? logoLink;
  String? bannerLink;
  String? url;
  String? contactEmail;
  String? address;
  String? city;
  String? zipCode;
  String? state;
  String? country;
  String? emailId;
  int? mobilePhone;
  int? locked;
  int? deleted;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  List<BusinessLegal>? businessLegal;

  Business(
      {this.name,
      this.punchLine,
      this.description,
      this.splashScreen,
      this.logoLink,
      this.bannerLink,
      this.url,
      this.contactEmail,
      this.address,
      this.city,
      this.zipCode,
      this.state,
      this.country,
      this.emailId,
      this.mobilePhone,
      this.locked,
      this.deleted,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.businessLegal});

  Business.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    punchLine = json['punch_line'];
    description = json['description'];
    splashScreen = json['splash_screen'];
    logoLink = json['logo_link'];
    bannerLink = json['banner_link'];
    url = json['url'];
    contactEmail = json['contact_email'];
    address = json['address'];
    city = json['city'];
    zipCode = json['zip_code'];
    state = json['state'];
    country = json['country'];
    emailId = json['email_id'];
    mobilePhone = json['mobile_phone'];
    locked = json['locked'];
    deleted = json['deleted'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    if (json['business_legal'] != null) {
      businessLegal = <BusinessLegal>[];
      json['business_legal'].forEach((v) {
        businessLegal!.add(BusinessLegal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['punch_line'] = this.punchLine;
    data['description'] = this.description;
    data['splash_screen'] = this.splashScreen;
    data['logo_link'] = this.logoLink;
    data['banner_link'] = this.bannerLink;
    data['url'] = this.url;
    data['contact_email'] = this.contactEmail;
    data['address'] = this.address;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['state'] = this.state;
    data['country'] = this.country;
    data['email_id'] = this.emailId;
    data['mobile_phone'] = this.mobilePhone;
    data['locked'] = this.locked;
    data['deleted'] = this.deleted;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    if (this.businessLegal != null) {
      data['business_legal'] =
          this.businessLegal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusinessLegal {
  String? legalId;
  String? title;

  BusinessLegal({this.legalId, this.title});

  BusinessLegal.fromJson(Map<String, dynamic> json) {
    legalId = json['legal_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['legal_id'] = this.legalId;
    data['title'] = this.title;
    return data;
  }
}
