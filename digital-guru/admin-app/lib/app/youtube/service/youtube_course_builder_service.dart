//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/course/service/course_service.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/instructor/service/instructor_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/youtube/model/channel_model.dart';
import 'package:digiguru/app/youtube/model/video_model.dart';
import 'package:digiguru/app/youtube/service/api_service.dart';

class YoutubeCourseBuilderService extends BaseService {
  CourseService _courseService = locator<CourseService>();
  ModuleService _moduleService = locator<ModuleService>();
  LessonService _lessonService = locator<LessonService>();
  InstructorService _instructorService = locator<InstructorService>();
  // final CollectionReference _courseCollectionReference =
  //     FirebaseFirestore.instance.collection('courses');
  // final CollectionReference _lessonCollectionReference =
  //     FirebaseFirestore.instance.collection('lessons');
  // final CollectionReference _moduleCollectionReference =
  //     FirebaseFirestore.instance.collection('modules');
  // final CollectionReference _instructorsCollectionReference =
  //    FirebaseFirestore.instance.collection('instructors');

  APIService api = locator<APIService>();

  void addChannelCourse(YoutubeCourseInfo info) async {
    String playlist = info.playlists.join(',');
    Channel channel =
        await api.fetchChannel(channelId: info.channelId, playlist: playlist);

    Instructor instructor =
        await _instructorService.getInstructorByName(info.instructorName);
    if (instructor == null) {
      var snapshot = await _instructorService.addInstructor(Instructor(
          businessId: info.businessId,
          fullName: info.instructorName,
          profilePic: channel.profilePictureUrl!,
          documentId: channel.id!));
      instructor = Instructor.fromJson(
          docId: snapshot.id, json: snapshot.data() as Map<String, dynamic>);
    }

    Course course = Course(
      businessId: info
          .businessId, //  oAq9WHcJ5DdTmwJZfjaq   BaseService.currentBusiness.documentId,
      title: channel.title!,
      instructorName: info.instructorName,
      displayOrder: 0,
      language: info.language,
      instructorId: instructor.documentId,
      lessonCount: 0,
      youtube: true,
    );

    var _courseDocRef = await _courseService.addCourse(course);

    List<Module> modules = List.empty(growable: true);
    int index = 1;
    channel.playLists?.forEach((pl) async {
      var _moduleDocRef;
      Module m = Module(
        courseId: _courseDocRef.id,
        businessId: info.businessId, //BaseService.currentBusiness.documentId,
        name: "",
        title: pl.title!,
        published: true,
        lessonCount: pl.videoCount!,
        displayOrder: index, tags: [],
      );
      _moduleDocRef = await _moduleService.addModule(m);
      index++;
      List<Video> videos = await api.fetchVideosFromPlaylist(
          nameIndex: info.nameIndex, playlistId: pl.id!);
      int lIndex = 0;
      videos.forEach((video) async {
        await _lessonService.addLesson(Lesson(
            businessId: info.businessId,
            courseId: _courseDocRef.id,
            moduleId: _moduleDocRef.id,
            title: video.title,
            courseTitle: channel.title!,
            freeTrial: true,
            locked: false,
            displayOrder: lIndex++,
            instructorName: info.instructorName,
            moduleTitle: m.title,
            videoInfo: VideoInfo(
                youtube: true,
                duration: video.duration,
                thumbUrl: video.thumbnailUrl,
                videoUrl: video.id)));
      });
    });
  }

  Future deleteCourse(String courseId) async {
    _lessonService.deleteCourseLessions(courseId);
    _moduleService.deleteCourseModules(courseId);
    _courseService.deleteCourseById(courseId);
  }
}

class YoutubeCourseInfo {
  String businessId;
  String channelId;
  String instructorName;
  String language;
  List<String> playlists;
  int maxVideoCount;
  int nameIndex;

  YoutubeCourseInfo(
      {required this.businessId,
      required this.channelId,
      required this.instructorName,
      required this.language,
      required this.playlists,
      required this.maxVideoCount,
      required this.nameIndex});
}
