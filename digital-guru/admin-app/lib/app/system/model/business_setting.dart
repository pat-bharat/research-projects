class BusinessSetting {
  String businessId;
  int maxCourses;
  int maxModulePerCourse;
  int maxVideoDuration;
  int lessonsPerModule;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  String documetnId;
  BusinessSetting(
      {this.businessId,
      this.maxCourses = 3,
      this.maxModulePerCourse = 5,
      this.maxVideoDuration = 600,
      this.lessonsPerModule = 10,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  BusinessSetting.fromJson(String docId, Map<String, dynamic> json) {
    this.documetnId = docId;
    businessId = json['business_id'];
    maxCourses = json['max_courses'];
    maxModulePerCourse = json['max_module_per_course'];
    maxVideoDuration = json['max_video_duration'];
    lessonsPerModule = json['max_lessons_per_module'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['max_courses'] = this.maxCourses;
    data['max_module_per_course'] = this.maxModulePerCourse;
    data['max_video_duration'] = this.maxVideoDuration;
    data['max_lessons_per_module'] = this.lessonsPerModule;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
