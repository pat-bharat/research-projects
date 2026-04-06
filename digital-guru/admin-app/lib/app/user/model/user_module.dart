import 'package:digiguru/app/lesson/model/lesson.dart';

class UserModule {
  String? userId;
  String? purchaseDate;
  double? purchaseAmount;
  bool? certified;
  String? courseId;
  String? courseName;
  String? instructorName;
  String? moduleId;
  String? moduleName;
  String? moduleTitle;
  List<String>? lessonIds;
  List<Lesson>? lessons;
  String? id;

  UserModule({
    required this.userId,
    this.purchaseDate,
    this.purchaseAmount,
    this.certified,
    this.courseId,
    this.courseName,
    this.instructorName,
    this.moduleId,
    this.moduleName,
    this.moduleTitle,
    this.lessonIds,
    this.lessons,
  });

  UserModule.fromJson(String docId, Map<String, dynamic> json) {
    this.id = docId;
    userId = json['user_id'];
    purchaseDate = json['purchase_date'];
    purchaseAmount = json['purchase_amount'];
    certified = json['certified'];
    courseId = json['course_id'];
    courseName = json['course_name'];
    instructorName = json['instructor_name'];
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    moduleTitle = json['module_title'];
    //lessonIds = json['lessons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['purchase_date'] = this.purchaseDate;
    data['purchase_amount'] = this.purchaseAmount;
    data['certified'] = this.certified;
    data['course_id'] = this.courseId;
    data['course_name'] = this.courseName;
    data['instructor_name'] = this.instructorName;
    data['module_id'] = this.moduleId;
    data['module_name'] = this.moduleName;
    data['module_title'] = this.moduleTitle;
    // data['lessons'] = this.lessonIds;
    return data;
  }
}
