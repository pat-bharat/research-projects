import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/video/model/video_info.dart';

class Module {
  String courseId;
  String businessId;
  String name;
  String title;
  double purchaseAmount;
  int discountPercentage;
  bool published;
  bool deleted;
  int displayOrder;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  List<String> tags = List<String>.empty(growable: true);
  List<PricePlan> pricePlan;
  ModuleBackground moduleBackground;
  ModuleDetailDoc moduleDetailDoc;
  VideoInfo moduleVideo;
  int lessonCount;

  String documentId;
  Course course;

  Module(
      {this.courseId,
      this.businessId,
      this.name,
      this.title,
      this.purchaseAmount,
      this.discountPercentage,
      this.published,
      this.deleted,
      this.displayOrder,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.tags,
      this.pricePlan,
      this.moduleBackground,
      this.moduleDetailDoc,
      this.moduleVideo,
      this.lessonCount});

  Module.fromJson(Map<String, dynamic> json, String docId) {
    this.documentId = docId;
    courseId = json['course_id'];
    businessId = json['business_id'];
    name = json['name'];
    title = json['title'];
    purchaseAmount = json['purchase_amount'];
    discountPercentage = json['discount_percentage'];
    published = json['published'];
    deleted = json['deleted'];
    displayOrder = json['display_order'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    tags = json['tags'] != null
        ? json['tags'].cast<String>()
        : List<String>.empty(growable: true);
    lessonCount = json['lesson_count'];
    if (json['price_plan'] != null) {
      pricePlan = new List<PricePlan>.empty(growable: true);
      json['price_plan'].forEach((v) {
        pricePlan.add(new PricePlan.fromJson(v));
      });
    }
    moduleBackground = json['module_background'] != null
        ? new ModuleBackground.fromJson(json['module_background'])
        : new ModuleBackground();
    moduleDetailDoc = json['module_detail_doc'] != null
        ? new ModuleDetailDoc.fromJson(json['module_detail_doc'])
        : new ModuleDetailDoc();
    moduleVideo = json['module_video'] != null
        ? new VideoInfo.fromJson(json['module_video'])
        : new VideoInfo();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['business_id'] = this.businessId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['purchase_amount'] = this.purchaseAmount;
    data['discount_percentage'] = this.discountPercentage;
    data['published'] = this.published;
    data['deleted'] = this.deleted;
    data['display_order'] = this.displayOrder;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    data['tags'] = this.tags;
    data['lesson_count'] = this.lessonCount;
    if (this.pricePlan != null) {
      data['price_plan'] = this.pricePlan.map((v) => v.toJson()).toList();
    }
    if (this.moduleBackground != null) {
      data['module_background'] = this.moduleBackground.toJson();
    }
    if (this.moduleDetailDoc != null) {
      data['module_detail_doc'] = this.moduleDetailDoc.toJson();
    }
    if (this.moduleVideo != null) {
      data['module_video'] = this.moduleVideo.toJson();
    }

    return data;
  }
}

class PricePlan {
  String name;
  String price;

  PricePlan({this.name, this.price});

  PricePlan.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class ModuleBackground {
  String title;
  String imageUrl;
  String imageSize;

  ModuleBackground({this.title, this.imageUrl, this.imageSize});

  ModuleBackground.fromJson(Map<String, dynamic> json) {
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

class ModuleDetailDoc {
  String title;
  String docUrl;
  String docSize;

  ModuleDetailDoc({this.title, this.docUrl, this.docSize});

  ModuleDetailDoc.fromJson(Map<String, dynamic> json) {
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

class ModuleVideo {
  String title;
  String videoUrl;
  String thumbUrl;
  String coverUrl;
  String videoSize;
  bool finishedPrcessing;
  bool uploadUrl;
  String rawVideoPath;
  bool uploadComplete;

  ModuleVideo(
      {this.title,
      this.videoUrl,
      this.thumbUrl,
      this.coverUrl,
      this.videoSize,
      this.finishedPrcessing,
      this.uploadUrl,
      this.rawVideoPath,
      this.uploadComplete});

  ModuleVideo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    videoUrl = json['video_url'];
    thumbUrl = json['thumb_url'];
    coverUrl = json['cover_url'];
    videoSize = json['video_size'];
    finishedPrcessing = json['finished_prcessing'];
    uploadUrl = json['upload_url'];
    rawVideoPath = json['raw_video_path'];
    uploadComplete = json['upload_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['video_url'] = this.videoUrl;
    data['thumb_url'] = this.thumbUrl;
    data['cover_url'] = this.coverUrl;
    data['video_size'] = this.videoSize;
    data['finished_prcessing'] = this.finishedPrcessing;
    data['upload_url'] = this.uploadUrl;
    data['raw_video_path'] = this.rawVideoPath;
    data['upload_complete'] = this.uploadComplete;
    return data;
  }
}
