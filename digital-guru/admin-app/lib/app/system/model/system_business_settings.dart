class SystemBusinessSettings {
  String? businessId;
  int? maxMediaPerLesson;
  int? maxModulePerCourse;
  int? maxVideoDuration;
  int? maxAdminUsers;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? modifiedBy;

  SystemBusinessSettings(
      {this.businessId,
      this.maxMediaPerLesson,
      this.maxModulePerCourse,
      this.maxVideoDuration,
      this.maxAdminUsers,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.modifiedBy});

  SystemBusinessSettings.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    maxMediaPerLesson = json['max_media_per_lesson'];
    maxModulePerCourse = json['max_module_per_course'];
    maxVideoDuration = json['max_video_duration'];
    maxAdminUsers = json['max_admin_users'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['max_media_per_lesson'] = this.maxMediaPerLesson;
    data['max_module_per_course'] = this.maxModulePerCourse;
    data['max_video_duration'] = this.maxVideoDuration;
    data['max_admin_users'] = this.maxAdminUsers;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
