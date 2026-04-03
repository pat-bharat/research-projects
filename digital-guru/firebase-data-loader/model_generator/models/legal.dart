class Legal {
  String? businessId;
  String? title;
  String? description;
  String? active;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifiedBy;

  Legal({
    this.businessId,
    this.title,
    this.description,
    this.active,
    this.createdTimestamp,
    this.updatedTimestamp,
    this.deletedTimestamp,
    this.modifiedBy,
  });

  Legal.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    title = json['title'];
    description = json['description'];
    active = json['active'];
    createdTimestamp = json['created_timestamp'];
    updatedTimestamp = json['updated_timestamp'];
    deletedTimestamp = json['deleted_timestamp'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessId != null) data['business_id'] = businessId;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (active != null) data['active'] = active;
    if (createdTimestamp != null) data['created_timestamp'] = createdTimestamp;
    if (updatedTimestamp != null) data['updated_timestamp'] = updatedTimestamp;
    if (deletedTimestamp != null) data['deleted_timestamp'] = deletedTimestamp;
    if (modifiedBy != null) data['modified_by'] = modifiedBy;
    return data;
  }
}
