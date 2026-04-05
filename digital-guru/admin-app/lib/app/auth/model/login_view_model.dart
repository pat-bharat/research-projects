import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/shared_services/analytics_service.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/user/service/user_service.dart';

import '../../common/model/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserService _userService = locator<UserService>();

  Future isLegalAcceptedByUser() async {
    return await _userService.hasUserAcceptedLegals(currentUser?.documentId ?? '');
  }

  Future loginWithEmail({
    required String email,
    required String password,
  }) async {
    setBusy(true);
    String? businessId;
    
    businessId = appConfig.businessId;
  
    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
      businessId: businessId,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logLogin();
        _navigationService.navigateTo(CourseViewListRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
    _dectateNextRoute();
  }

  Future loginWithGoogleId(String role) async {
    return await _authenticationService.signUpWithGoogle(role: role);
  }

  void _dectateNextRoute() async {
    bool isLegalAccepted = await isLegalAcceptedByUser();
    if (isLegalAccepted) {
      if (super.isAdmin) {
        if (currentBusiness != null) {
          _navigationService.navigateTo(CourseViewListRoute);
        } else {
          _navigationService.navigateTo(CreateBusinessViewRoute);
        }
      }
    }else{
      _navigationService.navigateTo(AcceptLegalViewRoute);
    }
  }

  Future sendForgotPasswordLinkEmail({required String email}) async {
    setBusy(true);

    await _authenticationService.sendPasswordEmail(email: email);
    setBusy(false);
    _navigationService.pop();
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }

  void navigateToForgotPassword() {
    _navigationService.navigateTo(ForgotPasswordViewRoute);
  }
}
