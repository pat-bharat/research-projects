import 'package:digital_guru/app/course/model/course.dart';

import 'package:firestore_service/firestore_service.dart';

class CourseService {
  CourseService(this.service);

  FirestoreService service;

  Stream<List<Course>> coursesStream() => service.collectionStream(
        path: "course",
        builder: (data, documentId) => Course.fromJson(data),
      );
}
