import 'package:digiguru/app/billing/service/business_billing_service.dart';
import 'package:digiguru/app/business/service/business_legal_service.dart';
import 'package:digiguru/app/shared_services/analytics_service.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/course/service/course_service.dart';
//import 'package:digiguru/app/firebase_services/service/supabase_file_storage.dart';
import 'package:digiguru/app/instructor/service/instructor_service.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/shared_services/dynamic_link_service.dart';
import 'package:digiguru/app/shared_services/push_notification_service.dart';
import 'package:digiguru/app/shared_services/remote_config_service.dart';
import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:digiguru/app/purchase/service/purchase_service.dart';
import 'package:digiguru/app/system/service/system_service.dart';
import 'package:digiguru/app/tools/data_loader.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:digiguru/app/youtube/service/youtube_course_builder_service.dart';
import 'package:digiguru/app/user/service/user_module_service.dart';
import 'package:digiguru/app/user/service/user_service.dart';
import 'package:digiguru/app/video/service/download_service.dart';
import 'package:digiguru/app/youtube/service/api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => MediaSelector());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => BusinessService());
  locator.registerLazySingleton(() => CourseService());
  locator.registerLazySingleton(() => ModuleService());
  locator.registerLazySingleton(() => LessonService());
  locator.registerLazySingleton(() => InstructorService());
  locator.registerLazySingleton(() => SystemService());
  locator.registerLazySingleton(() => UserModuleService());
  locator.registerLazySingleton(() => BusinessBillingService());
  locator.registerLazySingleton(() => BusinessLegalService());
  locator.registerLazySingleton(() => DownloadService.instance);
  locator.registerLazySingleton(() => PurchaseService());
  locator.registerLazySingleton(() => DataLoaderService());
  locator.registerLazySingleton(() => APIService());
  locator.registerLazySingleton(() => YoutubeCourseBuilderService());
  locator.registerLazySingleton(() => MediaUploadService());

  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}
