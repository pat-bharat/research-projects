class Publication {
  int courseCounts;
  int totalModuleCounts;
  int purchasedModuleCounts;
  int lessonCounts;
  int businessCounts;

  Publication(
      {this.courseCounts = 0,
      this.totalModuleCounts = 0,
      this.lessonCounts = 0,
      this.businessCounts = 0});

  Publication.fromJson(Map<String, dynamic> json) {
    courseCounts = json['course_counts'] ??= 0;
    totalModuleCounts = json['total_module_counts'] ??= 0;
    purchasedModuleCounts = json['purchased_module_counts'] ??= 0;
    lessonCounts = json['lesson_counts'] ??= 0;
    businessCounts = json['business_counts'] ??= 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_counts'] = this.courseCounts ??= 0;
    data['total_module_counts'] = this.totalModuleCounts ??= 0;
    data['purchased_module_counts'] = this.purchasedModuleCounts ??= 0;
    data['lesson_counts'] = this.lessonCounts ??= 0;
    data['business_counts'] = this.businessCounts ??= 0;
    return data;
  }
}
