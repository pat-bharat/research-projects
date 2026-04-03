class Course {
  String? businessId;
  String? title;
  String? description;
  String? instructorId;
  String? backgroundImage;
  int? deleted;
  int? displayOrder;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  List<CourseModule>? courseModule;

  Course(
      {this.businessId,
      this.title,
      this.description,
      this.instructorId,
      this.backgroundImage,
      this.deleted,
      this.displayOrder,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.courseModule});

  Course.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    title = json['title'];
    description = json['description'];
    instructorId = json['instructor_id'];
    backgroundImage = json['background_image'];
    deleted = json['deleted'];
    displayOrder = json['display_order'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    if (json['course_module'] != null) {
      courseModule = <CourseModule>[];
      json['course_module'].forEach((v) {
        courseModule!.add(CourseModule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['instructor_id'] = this.instructorId;
    data['background_image'] = this.backgroundImage;
    data['deleted'] = this.deleted;
    data['display_order'] = this.displayOrder;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    if (this.courseModule != null) {
      data['course_module'] = this.courseModule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CourseModule {
  String? moduleId;
  String? moduleName;
  String? lessonCount;

  CourseModule({this.moduleId, this.moduleName, this.lessonCount});

  CourseModule.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    lessonCount = json['lesson_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_id'] = this.moduleId;
    data['module_name'] = this.moduleName;
    data['lesson_count'] = this.lessonCount;
    return data;
  }
}
