import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/auth/page/forgot_password_view.dart';
import 'package:digiguru/app/auth/page/login_view.dart';
import 'package:digiguru/app/billing/page/business_invoice_list_view.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/page/business_dashboard_view.dart';
import 'package:digiguru/app/business/page/business_legal_list_view.dart';
import 'package:digiguru/app/business/page/business_view.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/widget/image_viewer.dart';
import 'package:digiguru/app/common/widget/pdf_viewer.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/course/page/course_list_view.dart';
import 'package:digiguru/app/course/page/course_view.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/instructor/page/instructor_list_view.dart';
import 'package:digiguru/app/instructor/page/instructor_view.dart';
import 'package:digiguru/app/lesson/model/lesson_view_list_model.dart';
import 'package:digiguru/app/lesson/page/lesson_list_view..dart';
import 'package:digiguru/app/lesson/page/lesson_view..dart';
import 'package:digiguru/app/module/model/module_list_model.dart';
import 'package:digiguru/app/module/page/module_list_view.dart';
import 'package:digiguru/app/module/page/module_view.dart';
import 'package:digiguru/app/signup/page/signup_view.dart';
import 'package:digiguru/app/startup/page/accept_legal_view.dart';
import 'package:digiguru/app/startup/page/startup_view.dart';
import 'package:digiguru/app/system/page/system_business_management_view.dart';
import 'package:digiguru/app/system/page/system_profile_view.dart';
import 'package:digiguru/app/user/page/purchased_user_module_list_view..dart';
import 'package:digiguru/app/user/page/trial_user_module_list_view.dart';
import 'package:digiguru/app/user/page/user_profile_view.dart';
import 'package:digiguru/app/video/page/download_queue_view.dart';
import 'package:digiguru/app/video/page/supabase_upload_queue_view.dart';
import 'package:digiguru/app/video/page/video_player.dart';
import 'package:digiguru/app/youtube/page/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Route<dynamic> generateRoute({required RouteSettings settings}) {
  switch (settings.name) {
    //login and signup
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case ForgotPasswordViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotPasswordView(),
      );
    case StartUpViewRoute:
      AppConfig? appConfig = settings.arguments as AppConfig?;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: StartUpView(appConfig: appConfig),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CourseListView(),
      );
    //Courses
    case CreateCourseViewRoute:
      Course? courseToEdit;
      if (settings.arguments is Course) {
        courseToEdit = settings.arguments as Course;
      }

      return _getPageRoute(
        viewToShow: CourseView(editingCourse: courseToEdit!),
      );
    case CourseViewListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CourseListView(),
      );
    //Modules
    case ModuleViewListRoute:
      Course? course;
      if (settings.arguments is Course) {
        course = settings.arguments as Course;
      }
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ModuleListView(course: course!),
      );
    case AddUpadateModuleViewRoute:
      CourseModuleArgs cm = settings.arguments as CourseModuleArgs;

      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ModuleView(editingModule: cm.module!, course: cm.course),
      );
    //Business
    case CreateBusinessViewRoute:
      Business? businessToEdit;
      if (settings.arguments != null && settings.arguments is Business) {
        businessToEdit = settings.arguments as Business;
      }
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BusinessView(editingBusiness: businessToEdit!),
      );
    case BusinessLegalListViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BusinessLegalListView(),
      );
    case BusinessInvoiceListViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BusinessInvoiceListView(),
      );
    case BusinessDashboardViewRoute:
      Business? business;
      if (settings.arguments != null && settings.arguments is Business) {
        business = settings.arguments as Business;
      }
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BusinessDashBoardView(business: business!),
      );
    //Lessons
    case LessonViewListRoute:
      CourseModuleArgs? _courseModule;
      if (settings.arguments is CourseModuleArgs) {
        _courseModule = settings.arguments as CourseModuleArgs;
      }
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LessonListView(
            course: _courseModule!.course, module: _courseModule.module!),
      );
    case CreateLessonViewRoute:
      CourseModuleLessonsArgs ml =
          settings.arguments as CourseModuleLessonsArgs;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LessonView(
            course: ml.course, module: ml.module, editingLesson: ml.lesson!),
      );
    //instructors
    case InstructorListViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InstructorListView(),
      );
    case AddEditInstructorViewRoute:
      Instructor? instructor;
      if (settings.arguments is Instructor) {
        instructor = settings.arguments as Instructor;
      }
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InstructorView(editingInstructor: instructor!),
      );
    //Users
    case FreeUserModuleListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TrialUserModuleListView(),
      );
    case PurchasedUserModuleListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PurchasedUserModuleListView(),
      );
    case ViewPdfRoute:
      String pdfUrl = settings.arguments! as String;
      //settings.arguments;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PdfViewer(url: pdfUrl),
      );
    case ViewImageRoute:
      String url = settings.arguments! as String;
      //settings.arguments;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ImageViewer(url: url),
      );
    case ViewVideoRoute:
      String url = settings.arguments! as String;
      //settings.arguments;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: VideoPlayer(url: url),
      );
    case YoutubeVideoRoute:
      String id = settings.arguments! as String;
      //settings.arguments;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: VideoScreen(
          id: id,
        ),
      );
    case ViewDownloadQueueRoute:
      TargetPlatform platform = settings.arguments! as TargetPlatform;
      //settings.arguments;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DownloadQueueView(platform: platform, title: 'Downloads'),
      );
    case ViewUploadQueueRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SupabaseUploadQueueView(),
      );
    //System
    case SystemProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SystemProfileView(),
      );
    case SystemBusinessManagementViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SystemBusinessManagementView(),
      );
    case AcceptLegalViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AcceptLegalView(),
      );

    case UserProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserProfileView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String? routeName, required Widget viewToShow}) {
  return PageTransition(
    child: viewToShow,
    type: PageTransitionType.fade,
    settings: RouteSettings(
      name: routeName,
    ),
  );
  /*return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);*/
}
