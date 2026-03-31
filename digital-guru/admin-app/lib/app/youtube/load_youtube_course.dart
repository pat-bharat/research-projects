import 'package:digiguru/app/common/constants/youtube_channels.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/youtube/service/youtube_course_builder_service.dart';
import 'package:digiguru/app/youtube/page/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  await setupLocator();
  YoutubeCourseBuilderService service = locator<YoutubeCourseBuilderService>();
  service.deleteCourse("FhxS4Y53HNabF2KnXwb1");
  service.deleteCourse("yZjlQIWOGGWHMv2h4xPl");
  service.addChannelCourse(chandraniSharma);
  service.addChannelCourse(easyFluteSchool);
} //runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter YouTube API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}
