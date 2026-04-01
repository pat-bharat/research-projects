import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/common/constants/dialog_manager.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/firebase_services/service/analytics_service.dart';
import 'package:digiguru/app/routing/router.dart';
import 'package:digiguru/app/startup/page/startup_view.dart';
import 'package:digiguru/app/theme/service/theme_service.dart';
import 'package:digiguru/app/theme/theme_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  Intl.defaultLocale = 'en_US';
  // Register all the models and services before the app starts
  await setupLocator();
  AppConfig appConfig = await AppConfig.forEnvironment('dev');
  runApp(MyApp(appConfig));
}

class MyApp extends StatefulWidget {
  final AppConfig appConfig;
  MyApp(this.appConfig);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppConfig appConfig;
  @override
  initState() {
    super.initState();
    appConfig = widget.appConfig;
    /* var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_upload');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {},
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {},
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Guru',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child!)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      theme: ThemeService().getTheme(context, ThemeColor.red),
      home: StartUpView(appConfig: appConfig),
      onGenerateRoute: (settins) => generateRoute(settings: settins),
    );
  }
}
