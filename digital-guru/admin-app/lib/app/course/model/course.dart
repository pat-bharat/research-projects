import 'package:digiguru/app/video/model/video_info.dart';

class Course {
  String? businessId;
  String? title;
  String? description;
  String? instructorId;
  String? instructorName;
  String? instructorEmail;
  String? instructorPhone;
  bool? deleted;
  bool? published;
  int? displayOrder;
  int? lessonCount;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  CourseBackground? background;
  CourseDetailDoc? courseDetailDoc;
  VideoInfo? courseVideo;
  String? id;
  String? language;
  bool youtube;
  Course(
      {this.businessId,
      this.title,
      this.description,
      this.instructorId,
      this.instructorName,
      this.instructorEmail,
      this.instructorPhone,
      this.deleted,
      this.published,
      this.displayOrder,
      this.lessonCount,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.background,
      this.courseDetailDoc,
      this.courseVideo,
      this.language,
      this.youtube = false});

  Course.fromJson(Map<String, dynamic> json, String id) : youtube = json['youtube'] ?? false {
    this.id = id;
    businessId = json['business_id'];
    title = json['title'];
    description = json['description'];
    language = json['language'];
    instructorId = json['instructor_id'];
    instructorName = json['instructor_name'];
    instructorEmail = json['instructor_email'];
    instructorPhone = json['instructor_phone'];
    deleted = json['deleted'];
    published = json['published'];
    displayOrder = json['display_order'];
    lessonCount = json['lesson_count'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    background = json['course_background'] != null
        ? new CourseBackground.fromJson(json['course_background'])
        : new CourseBackground();
    courseDetailDoc = json['course_detail_doc'] != null
        ? new CourseDetailDoc.fromJson(json['course_detail_doc'])
        : new CourseDetailDoc();
    courseVideo = json['course_video'] != null
        ? new VideoInfo.fromJson(json['course_video'])
        : new VideoInfo();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['language'] = this.language;
    data['instructor_id'] = this.instructorId;
    data['instructor_name'] = this.instructorName;
    data['instructor_email'] = this.instructorEmail;
    data['instructor_phone'] = this.instructorPhone;
    data['deleted'] = this.deleted;
    data['published'] = this.published;
    data['youtube'] = this.youtube;
    if (this.displayOrder != null) {
      data['display_order'] = this.displayOrder;
    }
    if (this.lessonCount != null) {
      data['lesson_count'] = this.lessonCount;
    }
    if (this.createdTimestamp != null) {
      data['created_timestamp'] = this.createdTimestamp;
    }

    data['updated_timestamp'] = this.updatedTimestamp;
    if (this.deletedTimestamp != null) {
      data['deleted_timestamp'] = this.deletedTimestamp;
    }
    if (this.modifiedBy != null) {
      data['modified_by'] = this.modifiedBy;
    }

    if (this.background != null) {
      data['course_background'] = this.background?.toJson();
    }
    if (this.courseDetailDoc != null) {
      data['course_detail_doc'] = this.courseDetailDoc?.toJson();
    }
    if (this.courseVideo != null) {
      data['course_video'] = this.courseVideo?.toJson();
    }
    return data;
  }
}

class CourseBackground {
  String? title;
  String? imageUrl;
  String? imageSize;

  CourseBackground({this.title, this.imageUrl, this.imageSize});

  CourseBackground.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageUrl = json['image_url'];
    imageSize = json['image_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['image_size'] = this.imageSize;
    return data;
  }
}

class CourseDetailDoc {
  String? title;
  String? docUrl;
  String? docSize;

  CourseDetailDoc({this.title, this.docUrl, this.docSize});

  CourseDetailDoc.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    docUrl = json['doc_url'];
    docSize = json['doc_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['doc_url'] = this.docUrl;
    data['doc_size'] = this.docSize;
    return data;
  }
}
