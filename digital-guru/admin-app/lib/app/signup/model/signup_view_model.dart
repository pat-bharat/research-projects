import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/firebase_services/service/analytics_service.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:flutter/foundation.dart';

import '../../common/model/base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUpWithEmail(
      {required String email,
      required String password,
      required String fullName,
      String? businessId}) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        role: _selectedRole,
        businessId: super.appConfig.businessId);

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logSignUp();
        _navigationService.navigateTo(StartUpViewRoute, arguments: appConfig);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  Future signUpWithFacebook() async {
    setBusy(true);
    var result =
        await _authenticationService.signUpWithFacebook(role: selectedRole);

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logSignUp();
        _navigationService.navigateTo(StartUpViewRoute, arguments: appConfig);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  Future googleSignUp() async {
    setBusy(true);
    var result =
        await _authenticationService.signUpWithGoogle(role: selectedRole);

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logSignUp();
        _navigationService.navigateTo(StartUpViewRoute, arguments: appConfig);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }
}
