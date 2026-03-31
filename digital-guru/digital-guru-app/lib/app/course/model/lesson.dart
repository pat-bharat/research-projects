class Lesson {
  int id;
  String title;
  String description;
  String instructorNotes;
  String groupId;
  String moduleId;
  String instructorId;
  int locked;
  int deleted;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;

  Lesson(
      {this.id,
      this.title,
      this.description,
      this.instructorNotes,
      this.groupId,
      this.moduleId,
      this.instructorId,
      this.locked,
      this.deleted,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    instructorNotes = json['instructor_notes'];
    groupId = json['group_id'];
    moduleId = json['module_id'];
    instructorId = json['Instructor_id'];
    locked = json['locked'];
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
    data['instructor_notes'] = this.instructorNotes;
    data['group_id'] = this.groupId;
    data['module_id'] = this.moduleId;
    data['Instructor_id'] = this.instructorId;
    data['locked'] = this.locked;
    data['deleted'] = this.deleted;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
