
class Lesson {
  String? moduleId;
  String? title;
  String? description;
  String? instructorNotes;
  int? locked;
  int? deleted;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  List<LessonMedia>? lessonMedia;

  Lesson({
    this.moduleId,
    this.title,
    this.description,
    this.instructorNotes,
    this.locked,
    this.deleted,
    this.createdTimestamp,
    this.updatedTimestamp,
    this.deletedTimestamp,
    this.modifiedBy,
    this.lessonMedia,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        moduleId: json['module_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        instructorNotes: json['instructor_notes'] as String?,
        locked: json['locked'] as int?,
        deleted: json['deleted'] as int?,
        createdTimestamp: json['created_timestamp'] as String?,
        updatedTimestamp: json['updated_timestamp'] as String?,
        deletedTimestamp: json['deleted_timestamp'] as String?,
        modifiedBy: json['modified_by'] as String?,
        lessonMedia: (json['lesson_media'] as List?)?.map((v) => LessonMedia.fromJson(v as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'module_id': moduleId,
        'title': title,
        'description': description,
        'instructor_notes': instructorNotes,
        'locked': locked,
        'deleted': deleted,
        'created_timestamp': createdTimestamp,
        'updated_timestamp': updatedTimestamp,
        'deleted_timestamp': deletedTimestamp,
        'modified_by': modifiedBy,
        'lesson_media': lessonMedia?.map((v) => v.toJson()).toList(),
      };
}


class LessonMedia {
  String? title;
  String? mediaType;
  String? mediaPath;
  String? mediaSize;
  String? mediaLength;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifyBy;

  LessonMedia({
    this.title,
    this.mediaType,
    this.mediaPath,
    this.mediaSize,
    this.mediaLength,
    this.createdTimestamp,
    this.updatedTimestamp,
    this.deletedTimestamp,
    this.modifyBy,
  });

  factory LessonMedia.fromJson(Map<String, dynamic> json) => LessonMedia(
        title: json['title'] as String?,
        mediaType: json['media_type'] as String?,
        mediaPath: json['media_path'] as String?,
        mediaSize: json['media_size'] as String?,
        mediaLength: json['media_length'] as String?,
        createdTimestamp: json['created_timestamp'] as String?,
        updatedTimestamp: json['updated_timestamp'] as String?,
        deletedTimestamp: json['deleted_timestamp'] as String?,
        modifyBy: json['modify_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'media_type': mediaType,
        'media_path': mediaPath,
        'media_size': mediaSize,
        'media_length': mediaLength,
        'created_timestamp': createdTimestamp,
        'updated_timestamp': updatedTimestamp,
        'deleted_timestamp': deletedTimestamp,
        'modify_by': modifyBy,
      };
}
