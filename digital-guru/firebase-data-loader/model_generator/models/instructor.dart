class Instructor {
  String fullName;
  String introduction;
  String profilePic;
  String url;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;

  Instructor(
      {this.fullName,
      this.introduction,
      this.profilePic,
      this.url,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp});

  Instructor.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    introduction = json['introduction'];
    profilePic = json['profile_pic'];
    url = json['url'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['introduction'] = this.introduction;
    data['profile_pic'] = this.profilePic;
    data['url'] = this.url;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    return data;
  }
}
