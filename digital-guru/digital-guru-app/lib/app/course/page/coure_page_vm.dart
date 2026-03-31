import 'package:digital_guru/app/course/model/course.dart';

import 'package:digital_guru/app/course/service/course_service.dart';

class CourePageViewModel {
  CourePageViewModel(this._service);
  CourseService _service;

  Stream<List<Course>> getAllCourses() {
    return _service?.coursesStream() ?? const Stream.empty();
  }
}
