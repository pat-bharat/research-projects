import 'package:digital_guru_app/app/course/model/course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  CourseService(this.firestore);

  final SupabaseClient firestore;

  Stream<List<Course>> coursesStream() {
    return firestore
        .from('course')
        .asStream()
        .map((snapshot) => snapshot.map((doc) => Course.fromJson(doc)).toList());
  }
}
