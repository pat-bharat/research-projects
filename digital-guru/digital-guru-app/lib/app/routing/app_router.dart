import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.emailPasswordSignInPage:
        // Use flutterfire_ui's SignInScreen for email/password sign-in
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignInScreen(
            providers: [
              //EmailProviderConfiguration(),
            ],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                // Optionally pop or navigate after sign-in
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }),
            ],
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // Return a fallback error page instead of null
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page not found: \'${settings.name}\'')),
          ),
          settings: settings,
        );
    }
  }
}
