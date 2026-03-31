class UserMedia {
  String userId;
  String moduleId;
  List<UserMedia> userMedia;

  UserMedia({this.userId, this.moduleId, this.userMedia});

  UserMedia.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    moduleId = json['module_id'];
    if (json['user_media'] != null) {
      userMedia = new List<UserMedia>();
      json['user_media'].forEach((v) {
        userMedia.add(new UserMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['module_id'] = this.moduleId;
    if (this.userMedia != null) {
      data['user_media'] = this.userMedia.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserMedia {
  String title;
  String description;
  String mediaType;
  String mediaPath;
  String nediaUrl;
  String mediaSize;
  String mediaLength;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifyBy;

  UserMedia(
      {this.title,
      this.description,
      this.mediaType,
      this.mediaPath,
      this.nediaUrl,
      this.mediaSize,
      this.mediaLength,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  UserMedia.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    mediaType = json['media_type'];
    mediaPath = json['media_path'];
    nediaUrl = json['nedia_url'];
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
    data['description'] = this.description;
    data['media_type'] = this.mediaType;
    data['media_path'] = this.mediaPath;
    data['nedia_url'] = this.nediaUrl;
    data['media_size'] = this.mediaSize;
    data['media_length'] = this.mediaLength;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modify_by'] = this.modifyBy;
    return data;
  }
}
