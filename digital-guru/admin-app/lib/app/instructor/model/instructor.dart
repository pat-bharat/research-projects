class Instructor {
  late String businessId;
  String? fullName;
  String? introduction;
  String? email;
  String? mobileNumber;
  String? country;
  String? profilePic;
  String? url;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;
  bool? deleted;

  late String documentId;

  Instructor(
      {required this.businessId,
      this.fullName,
      this.introduction,
      this.email,
      this.mobileNumber,
      this.country,
      this.profilePic,
      this.url,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.deletedTimestamp,
      this.modifiedBy,
      required this.documentId,
      this.deleted});

  Instructor.fromJson(
      {required String docId, required Map<String, dynamic> json}) {
    this.documentId = docId;
    businessId = json['business_id'];
    fullName = json['full_name'];
    introduction = json['introduction'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    country = json['country'];
    profilePic = json['profile_pic'];
    url = json['url'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['full_name'] = this.fullName;
    data['introduction'] = this.introduction;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['country'] = this.country;
    data['profile_pic'] = this.profilePic;
    data['url'] = this.url;
    if (this.createdTimestamp != null) {
      data['created_timestamp'] = this.createdTimestamp;
    }
    data['updated_timestamp'] = this.updatedTimestamp;
    data['deleted_timestamp'] = this.deletedTimestamp;
    data['modified_by'] = this.modifiedBy;
    data['deleted'] = this.deleted;
    return data;
  }
}
