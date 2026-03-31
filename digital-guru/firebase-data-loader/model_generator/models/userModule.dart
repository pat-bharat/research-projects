class UserModule {
  String userId;
  String moduleId;
  String purchaseDate;
  String completionDate;
  int certifyByInstructor;

  UserModule(
      {this.userId,
      this.moduleId,
      this.purchaseDate,
      this.completionDate,
      this.certifyByInstructor});

  UserModule.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    moduleId = json['module_id'];
    purchaseDate = json['purchase_date'];
    completionDate = json['completion_date'];
    certifyByInstructor = json['certify_by_instructor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['module_id'] = this.moduleId;
    data['purchase_date'] = this.purchaseDate;
    data['completion_date'] = this.completionDate;
    data['certify_by_instructor'] = this.certifyByInstructor;
    return data;
  }
}
