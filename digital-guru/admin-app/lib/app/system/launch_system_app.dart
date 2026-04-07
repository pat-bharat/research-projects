import 'package:digiguru/app/common/constants/dialog_manager.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/routing/router.dart';
import 'package:digiguru/app/shared_services/analytics_service.dart';
import 'package:digiguru/app/system/page/system_profile_view.dart';
import 'package:digiguru/app/theme/service/theme_service.dart';
import 'package:digiguru/app/theme/theme_colors.dart';
import 'package:digiguru/configure_supabase.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  await FlutterDownloader.initialize(debug: true);
  await setupLocator();
  //BaseService.currentUser = User(userRole: "System");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System-app',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child!)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
      theme: ThemeService().getTheme(context, ThemeColor.red),
      home: SystemProfileView(),
      onGenerateRoute: (settings) => generateRoute(settings: settings),
    );
  }
}
