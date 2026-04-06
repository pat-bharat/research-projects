class Business {
  String? name;
  String? punchLine;
  //String description;
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
  String? mobilePhone;
  bool? locked;
  bool? deleted;
  String? themeId;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  String? id;
  Business(
      {this.name,
      this.punchLine,
      //this.description,
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
      this.themeId,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  Business.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    name = json['name'];
    punchLine = json['punch_line'];
    //description = json['description'];
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
    themeId = json['theme_id'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['punch_line'] = this.punchLine;
    //data['description'] = this.description;
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
    data['theme_id'] = this.themeId;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;

    return data;
  }
}
