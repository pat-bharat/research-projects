
class User {
  String? businessId;
  String? loginId;
  int? userType;
  String? fullName;
  String? address;
  String? city;
  String? zipCode;
  String? state;
  String? country;
  String? birthDate;
  String? email;
  String? mobilePhone;
  int? locked;
  int? deleted;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  String? lastLoginTimestamp;
  Preferences? preferences;

  User({
    this.businessId,
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
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        businessId: json['business_id'] as String?,
        loginId: json['login_id'] as String?,
        userType: json['user_type'] as int?,
        fullName: json['full_name'] as String?,
        address: json['address'] as String?,
        city: json['city'] as String?,
        zipCode: json['zip_code'] as String?,
        state: json['state'] as String?,
        country: json['country'] as String?,
        birthDate: json['birth_date'] as String?,
        email: json['email'] as String?,
        mobilePhone: json['mobile_phone'] as String?,
        locked: json['locked'] as int?,
        deleted: json['deleted'] as int?,
        createdTimestamp: json['created_timestamp'] as String?,
        updatedTimestamp: json['updated_timestamp'] as String?,
        deletedTimestamp: json['deleted_timestamp'] as String?,
        modifiedBy: json['modified_by'] as String?,
        lastLoginTimestamp: json['last_login_timestamp'] as String?,
        preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : null,
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'login_id': loginId,
        'user_type': userType,
        'full_name': fullName,
        'address': address,
        'city': city,
        'zip_code': zipCode,
        'state': state,
        'country': country,
        'birth_date': birthDate,
        'email': email,
        'mobile_phone': mobilePhone,
        'locked': locked,
        'deleted': deleted,
        'created_timestamp': createdTimestamp,
        'updated_timestamp': updatedTimestamp,
        'deleted_timestamp': deletedTimestamp,
        'modified_by': modifiedBy,
        'last_login_timestamp': lastLoginTimestamp,
        if (preferences != null) 'preferences': preferences!.toJson(),
      };
}

class Preferences {
  int? downloadLessons;
  int? wifiDownloadOnly;

  Preferences({this.downloadLessons, this.wifiDownloadOnly});

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        downloadLessons: json['download_lessons'] as int?,
        wifiDownloadOnly: json['wifi_download_only'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'download_lessons': downloadLessons,
        'wifi_download_only': wifiDownloadOnly,
      };
}
