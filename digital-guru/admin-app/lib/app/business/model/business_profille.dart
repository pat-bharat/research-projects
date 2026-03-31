import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/model/publication.dart';
import 'package:digiguru/app/common/model/user_count.dart';
import 'package:digiguru/app/system/model/business_setting.dart';

class BusinessProfile {
  String businessId;
  String businessName;
  String businessPhone;
  String businessEmail;
  bool locked;
  String createdTimestamp;
  UserCount userCounts;
  double collectedRevenue;
  Publication publication;

  BusinessSetting businessSetting = BusinessSetting();
  List<BusinessLegal> businessLegal;

  String documentId;

  BusinessProfile(
      {this.businessId,
      this.businessName,
      this.businessPhone,
      this.businessEmail,
      this.locked,
      this.createdTimestamp,
      this.userCounts,
      this.collectedRevenue,
      this.publication,
      this.businessSetting,
      this.businessLegal});

  BusinessProfile.fromJson(String docId, Map<String, dynamic> json) {
    this.documentId = docId;
    businessId = json['business_id'];
    businessName = json['business_name'];
    businessPhone = json['business_phone'];
    businessEmail = json['business_email'];
    locked = json['locked'];
    createdTimestamp = json['created_timestamp'];
    userCounts = json['user_counts'] != null
        ? new UserCount.fromJson(json['user_counts'])
        : null;
    collectedRevenue = json['collected_revenue'];
    publication = json['publication'] != null
        ? new Publication.fromJson(json['publication'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['business_phone'] = this.businessPhone;
    data['business_email'] = this.businessEmail;
    data['locked'] = this.locked;
    data['created_timestamp'] = this.createdTimestamp;
    if (this.userCounts != null) {
      data['user_counts'] = this.userCounts.toJson();
    }
    data['collected_revenue'] = this.collectedRevenue;
    if (this.publication != null) {
      data['publication'] = this.publication.toJson();
    }
    return data;
  }
}
