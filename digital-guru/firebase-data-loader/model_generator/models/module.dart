class Module {
  String courseId;
  String title;
  String description;
  String discountPercentage;
  int locked;
  int deleted;
  int displayOrder;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;
  List<Tags> tags;
  List<PricePlan> pricePlan;
  List<ModuleMedia> moduleMedia;
  String lessonCount;

  Module(
      {this.courseId,
      this.title,
      this.description,
      this.discountPercentage,
      this.locked,
      this.deleted,
      this.displayOrder,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      this.tags,
      this.pricePlan,
      this.moduleMedia,
      this.lessonCount});

  Module.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    title = json['title'];
    description = json['description'];
    discountPercentage = json['discount_percentage'];
    locked = json['locked'];
    deleted = json['deleted'];
    displayOrder = json['display_order'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    if (json['price_plan'] != null) {
      pricePlan = new List<PricePlan>();
      json['price_plan'].forEach((v) {
        pricePlan.add(new PricePlan.fromJson(v));
      });
    }
    if (json['module_media'] != null) {
      moduleMedia = new List<ModuleMedia>();
      json['module_media'].forEach((v) {
        moduleMedia.add(new ModuleMedia.fromJson(v));
      });
    }
    lessonCount = json['lesson_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['discount_percentage'] = this.discountPercentage;
    data['locked'] = this.locked;
    data['deleted'] = this.deleted;
    data['display_order'] = this.displayOrder;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.pricePlan != null) {
      data['price_plan'] = this.pricePlan.map((v) => v.toJson()).toList();
    }
    if (this.moduleMedia != null) {
      data['module_media'] = this.moduleMedia.map((v) => v.toJson()).toList();
    }
    data['lesson_count'] = this.lessonCount;
    return data;
  }
}

class Tags {
  String name;

  Tags({this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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

class ModuleMedia {
  String title;
  String mediaType;
  String mediaPath;
  String mediaSize;
  String mediaLength;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifyBy;

  ModuleMedia(
      {this.title,
      this.mediaType,
      this.mediaPath,
      this.mediaSize,
      this.mediaLength,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  ModuleMedia.fromJson(Map<String, dynamic> json) {
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
