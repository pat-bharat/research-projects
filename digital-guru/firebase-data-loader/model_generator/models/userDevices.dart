class UserDevices {
  String? userId;
  List<UserDevice>? userDevice;

  UserDevices({this.userId, this.userDevice});

  UserDevices.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    if (json['user_device'] != null) {
      userDevice = <UserDevice>[];
      json['user_device'].forEach((v) {
        userDevice!.add(UserDevice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    if (this.userDevice != null) {
      data['user_device'] = this.userDevice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDevice {
  String? deviceType;
  String? appVersion;
  String? osVersion;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;

  UserDevice(
      {this.deviceType,
      this.appVersion,
      this.osVersion,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  UserDevice.fromJson(Map<String, dynamic> json) {
    deviceType = json['device_type'];
    appVersion = json['app_version'];
    osVersion = json['os_version'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_type'] = this.deviceType;
    data['app_version'] = this.appVersion;
    data['os_version'] = this.osVersion;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
