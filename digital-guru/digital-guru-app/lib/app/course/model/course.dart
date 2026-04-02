class Course {
  int? id;
  String? title;
  String? description;
  String? instructorId;
  String? instructorName;
  String? backgroundImage;
  int? deleted;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;

  Course(
      {this.id,
      this.title,
      this.description,
      this.instructorId,
      this.instructorName,
      this.backgroundImage,
      this.deleted,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    instructorId = json['instructor_id'];
    instructorName = json['instructor_name'];
    backgroundImage = json['background_image'];
    deleted = json['deleted'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['instructor_id'] = this.instructorId;
    data['instructor_name'] = this.instructorName;
    data['background_image'] = this.backgroundImage;
    data['deleted'] = this.deleted;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }

  String toString() {
    return toJson().toString();
  }
}
