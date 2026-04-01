class Media {
  int? id;
  String? title;
  String? mediaType;
  String? mediaContent;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifyBy;

  Media(
      {this.id,
      this.title,
      this.mediaType,
      this.mediaContent,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifyBy});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mediaType = json['media_type'];
    mediaContent = json['media_content'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifyBy = json['modify_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['media_type'] = this.mediaType;
    data['media_content'] = this.mediaContent;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modify_by'] = this.modifyBy;
    return data;
  }
}
