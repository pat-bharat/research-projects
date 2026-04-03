class UserModule {
  String? userId;
  String? moduleId;
  String? purchaseDate;
  String? completionDate;
  int? certifyByInstructor;

  UserModule({
    this.userId,
    this.moduleId,
    this.purchaseDate,
    this.completionDate,
    this.certifyByInstructor,
  });

  UserModule.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    moduleId = json['module_id'];
    purchaseDate = json['purchase_date'];
    completionDate = json['completion_date'];
    certifyByInstructor = json['certify_by_instructor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['module_id'] = moduleId;
    data['purchase_date'] = purchaseDate;
    data['completion_date'] = completionDate;
    data['certify_by_instructor'] = certifyByInstructor;
    return data;
  }
}
