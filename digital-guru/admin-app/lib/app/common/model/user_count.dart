class UserCount {
  int adminUsers;
  int consumerUsers;
  int trialUsers;
  int purchasedUsers;

  UserCount(
      {this.adminUsers = 0,
      this.consumerUsers = 0,
      this.trialUsers = 0,
      this.purchasedUsers = 0});

  UserCount.fromJson(Map<String, dynamic> json)
      : adminUsers = json['admin_users'] ?? 0,
        consumerUsers = json['consumer_users'] ?? 0,
        trialUsers = json['trial_users'] ?? 0,
        purchasedUsers = json['purchased_users'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_users'] = this.adminUsers;
    data['consumer_users'] = this.consumerUsers;
    data['trial_users'] = this.trialUsers;
    data['purchased_users'] = this.purchasedUsers;
    return data;
  }
}
