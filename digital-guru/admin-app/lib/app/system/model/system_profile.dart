import 'package:digiguru/app/common/model/publication.dart';
import 'package:digiguru/app/common/model/user_count.dart';

class SystemProfile {
  String? businessId;
  String? name;
  String? csPhone;
  String? csEmail;
  String? createdTimestamp;
  UserCount? userCounts;
  double? totalRevenue;
  Publication? publication;

  String? documentId;

  SystemProfile(
      {this.businessId,
      this.name,
      this.csPhone,
      this.csEmail,
      this.createdTimestamp,
      this.userCounts,
      this.totalRevenue,
      this.publication});

  SystemProfile.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    businessId = json['business_id'];
    name = json['name'];
    csPhone = json['cs_phone'];
    csEmail = json['cs_email'];
    createdTimestamp = json['created_timestamp'];
    userCounts = json['user_counts'] != null
        ? new UserCount.fromJson(json['user_counts'])
        : UserCount();
    totalRevenue = json['total_revenue'];
    publication = json['publication'] != null
        ? new Publication.fromJson(json['publication'])
        : Publication();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['name'] = this.name;
    data['cs_phone'] = this.csPhone;
    data['cs_email'] = this.csEmail;
    data['created_timestamp'] = this.createdTimestamp;
    if (this.userCounts != null) {
      data['user_counts'] = this.userCounts!.toJson();
    }
    data['total_revenue'] = this.totalRevenue;
    if (this.publication != null) {
      data['publication'] = this.publication!.toJson();
    }
    return data;
  }
}
