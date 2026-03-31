class Lesson {
  String moduleId;
  String title;
  String description;
  String instructorNotes;
  int locked;
  int deleted;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  List<LessonMedia> lessonMedia;

  Lesson(
      {this.moduleId,
      this.title,
      this.description,
      this.instructorNotes,
      this.locked,
      this.deleted,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.lessonMedia});

  Lesson.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    title = json['title'];
    description = json['description'];
    instructorNotes = json['instructor_notes'];
    locked = json['locked'];
    deleted = json['deleted'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    if (json['lesson_media'] != null) {
      lessonMedia = new List<LessonMedia>();
      json['lesson_media'].forEach((v) {
        lessonMedia.add(new LessonMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['instructor_notes'] = this.instructorNotes;
    data['locked'] = this.locked;
    data['deleted'] = this.deleted;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    if (this.lessonMedia != null) {
      data['lesson_media'] = this.lessonMedia.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LessonMedia {
  String title;
  String mediaType;
  String mediaPath;
  String mediaSize;
  String mediaLength;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifyBy;

  LessonMedia(
      {this.title,
      this.mediaType,
      this.mediaPath,
      this.mediaSize,
      this.mediaLength,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  LessonMedia.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    mediaType = json['media_type'];
    mediaPath = json['media_path'];
    mediaSize = json['media_size'];
    mediaLength = json['media_length'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifyBy = json['modify_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['media_type'] = this.mediaType;
    data['media_path'] = this.mediaPath;
    data['media_size'] = this.mediaSize;
    data['media_length'] = this.mediaLength;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modify_by'] = this.modifyBy;
    return data;
  }
}
