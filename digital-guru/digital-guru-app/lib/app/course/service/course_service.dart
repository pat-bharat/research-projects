import 'package:digital_guru_app/app/course/model/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  CourseService(this.firestore);

  final FirebaseFirestore firestore;

  Stream<List<Course>> coursesStream() {
    return firestore
        .collection('course')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson(doc.data()))
            .toList());
  }
}
