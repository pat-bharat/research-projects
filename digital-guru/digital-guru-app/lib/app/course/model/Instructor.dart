class Instructor {
  int id;
  String fullName;
  String introduction;
  String profilePic;
  String createdTimestamp;
  String updatedTimestamp;
  String deletedTimestamp;
  String modifiedBy;

  Instructor(
      {this.id,
      this.fullName,
      this.introduction,
      this.profilePic,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    introduction = json['Introduction'];
    profilePic = json['profile_pic'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['Introduction'] = this.introduction;
    data['profile_pic'] = this.profilePic;
    data['created_timestamp'] = this.createdTimestamp;
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
