import 'package:digital_guru/app/common/provider/top_level_providers.dart';
import 'package:digital_guru/app/course/model/course.dart';
import 'package:digital_guru/app/course/page/coure_page_vm.dart';
import 'package:digital_guru/app/course/service/course_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseServiceProvider = Provider<CourseService>(
    (ref) => CourseService(ref.watch(databaseProvider).service));

final courseViewModelProvider = Provider<CourePageViewModel>((ref) {
  return CourePageViewModel(ref.watch(courseServiceProvider));
});

final coursesStreamProvider = StreamProvider.autoDispose<List<Course>>((ref) {
  final courePageViewModel = ref.watch(courseViewModelProvider);
  return courePageViewModel?.getAllCourses() ?? const Stream.empty();
});
