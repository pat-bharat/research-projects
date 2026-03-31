class User {
  String userId;
  String businessId;
  String fullName;
  String email;
  String userRole;
  String country;
  String mobileNo;
  String profilePic;
  String createdTimestamp;
  String updatedTimestamp;
  String modifiedBy;
  String lastLoginTimestamp;
  UserPreferances userPreferances;

  String documentId;

  User(
      {this.userId,
      this.fullName,
      this.email,
      this.userRole,
      this.country,
      this.mobileNo,
      this.profilePic,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.modifiedBy,
      this.lastLoginTimestamp,
      this.userPreferances});

  User.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    fullName = json['full_name'];
    email = json['email'];
    userRole = json['user_role'];
    country = json['country'];
    mobileNo = json['mobile_no'];
    profilePic = json['profilePic'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    modifiedBy = json['modified_by'];
    lastLoginTimestamp = json['last_login_timestamp'];
    userPreferances = json['user_preferances'] != null
        ? new UserPreferances.fromJson(json['user_preferances'])
        : UserPreferances();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['user_role'] = this.userRole;
    data['country'] = this.country;
    data['mobile_no'] = this.mobileNo;
    data['profilePic'] = this.profilePic;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['modified_by'] = this.modifiedBy;
    data['last_login_timestamp'] = this.lastLoginTimestamp;
    if (this.userPreferances != null) {
      data['user_preferances'] = this.userPreferances.toJson();
    }
    return data;
  }
}

class UserPreferances {
  bool downloadLessons;
  bool wifiDownloadOnly;
  bool inAppNotifications;

  bool wifiUploadOnly;

  UserPreferances(
      {this.downloadLessons,
      this.wifiDownloadOnly,
      this.inAppNotifications,
      this.wifiUploadOnly});

  UserPreferances.fromJson(Map<String, dynamic> json) {
    wifiUploadOnly = json['wifi_upload_only'];
    downloadLessons = json['download_lessons'];
    wifiDownloadOnly = json['wifi_download_only'];
    inAppNotifications = json['in_app_notifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download_lessons'] = this.downloadLessons;
    data['wifi_download_only'] = this.wifiDownloadOnly;
    data['in_app_notifications'] = this.inAppNotifications;
    data['wifi_upload_only'] = this.wifiUploadOnly;
    return data;
  }
}
