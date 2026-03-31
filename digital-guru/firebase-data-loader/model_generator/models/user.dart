class User {
  String businessId;
  String loginId;
  int userType;
  String fullName;
  String address;
  String city;
  String zipCode;
  String state;
  String country;
  String birthDate;
  String email;
  String mobilePhone;
  int locked;
  int deleted;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  String lastLoginTimestamp;
  Preferances preferances;

  User(
      {this.businessId,
      this.loginId,
      this.userType,
      this.fullName,
      this.address,
      this.city,
      this.zipCode,
      this.state,
      this.country,
      this.birthDate,
      this.email,
      this.mobilePhone,
      this.locked,
      this.deleted,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.lastLoginTimestamp,
      this.preferances});

  User.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    loginId = json['login_id'];
    userType = json['user_type'];
    fullName = json['full_name'];
    address = json['address'];
    city = json['city'];
    zipCode = json['zip_code'];
    state = json['state'];
    country = json['country'];
    birthDate = json['birth_date'];
    email = json['email'];
    mobilePhone = json['mobile_phone'];
    locked = json['locked'];
    deleted = json['deleted'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    lastLoginTimestamp = json['last_login_timestamp'];
    preferances = json['preferances'] != null
        ? new Preferances.fromJson(json['preferances'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['login_id'] = this.loginId;
    data['user_type'] = this.userType;
    data['full_name'] = this.fullName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['state'] = this.state;
    data['country'] = this.country;
    data['birth_date'] = this.birthDate;
    data['email'] = this.email;
    data['mobile_phone'] = this.mobilePhone;
    data['locked'] = this.locked;
    data['deleted'] = this.deleted;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    data['last_login_timestamp'] = this.lastLoginTimestamp;
    if (this.preferances != null) {
      data['preferances'] = this.preferances.toJson();
    }
    return data;
  }
}

class Preferances {
  int downloadLessons;
  int wifiDownloadOnly;

  Preferances({this.downloadLessons, this.wifiDownloadOnly});

  Preferances.fromJson(Map<String, dynamic> json) {
    downloadLessons = json['download_lessons'];
    wifiDownloadOnly = json['wifi_download_only'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download_lessons'] = this.downloadLessons;
    data['wifi_download_only'] = this.wifiDownloadOnly;
    return data;
  }
}
