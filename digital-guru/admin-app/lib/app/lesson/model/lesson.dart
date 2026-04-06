import 'package:digiguru/app/video/model/video_info.dart';

class Lesson {
  String? moduleId;
  String? businessId;
  String? moduleTitle;
  String? courseId;
  String? courseTitle;
  String? title;
  String? instructorName;
  String? instructorNotes;
  bool locked = true;
  bool? deleted;
  bool? freeTrial;
  int? displayOrder;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  InstructionDoc? instructionDoc;
  VideoInfo? videoInfo;
  String? id;
  Lesson(
      {
      this.moduleId,
      this.businessId,
      this.moduleTitle,
      this.courseId,
      this.courseTitle,
      this.title,
      this.instructorName,
      this.instructorNotes,
      this.locked = true,
      this.deleted,
      this.freeTrial,
      this.displayOrder,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.instructionDoc,
      this.videoInfo});

  Lesson.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    moduleId = json['module_id'];
    businessId = json['business_id'];
    moduleTitle = json['module_title'];
    courseId = json['course_id'];
    courseTitle = json['course_title'];
    instructorName = json['instructor_name'];
    title = json['title'];
    instructorNotes = json['instructor_notes'];
    locked = json['locked'];
    deleted = json['deleted'];
    freeTrial = json['free_trial'];
    displayOrder = json['display_order'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    instructionDoc = json['instruction_doc'] != null
        ? new InstructionDoc.fromJson(json['instruction_doc'])
        : InstructionDoc();
    if (json['video_info'] != null) {
      videoInfo = VideoInfo.fromJson(json['video_info']);
    } else {
      videoInfo = VideoInfo();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
     data['business_id'] = this.businessId;
    data['module_title'] = this.moduleTitle;
    data['course_id'] = this.courseId;
    data['course_title'] = this.courseTitle;
    data['instructor_name'] = this.instructorName;
    data['title'] = this.title;
    data['instructor_notes'] = this.instructorNotes;
    data['locked'] = this.locked == null ? true : this.locked;
    data['deleted'] = this.deleted;
    data['free_trial'] = this.freeTrial;
    data['display_order'] = this.displayOrder;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    if (this.instructionDoc != null) {
      data['instruction_doc'] = this.instructionDoc?.toJson();
    }
    if (this.videoInfo != null) {
      data['video_info'] = this.videoInfo?.toJson();
    }
    return data;
  }
}

class InstructionDoc {
  String? title;
  String? docUrl;
  String? docSize;

  InstructionDoc({this.title, this.docUrl, this.docSize});

  InstructionDoc.fromJson(Map<String, dynamic> json) {
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
