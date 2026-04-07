import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/shared_services/dynamic_link_service.dart';
import 'package:digiguru/app/shared_services/push_notification_service.dart';
import 'package:digiguru/app/shared_services/remote_config_service.dart';
import 'package:digiguru/app/user/service/user_service.dart';

class StartUpViewModel extends BaseModel {
  // We'll be looking at Dependency Injection during our architecture review.
  // The next series will be on the refined and reviewed Mvvm architecture.
  // Dependency injection over service location is something that we're looking
  // at. VERY EXCITED ABOUT THE ARCHITECTURE UPDATES. We've built 6 apps with the current one
  // it works very well but there are some improvements that can be made.

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final DialogService _dialogService = locator<DialogService>();
  final UserService _userService = locator<UserService>();

  AppConfig appConfig;
  bool? tocAccepted;
  bool? privacyAccepted;
  StartUpViewModel({required this.appConfig}) : super();
  Future handleStartUpLogic() async {
    await _dynamicLinkService.handleDynamicLinks();
    await _remoteConfigService.initialise();

    // Register for push notifications
    await _pushNotificationService.initialise();

    var hasLoggedInUser = await _authenticationService.isUserLoggedIn(
        businessId: appConfig.businessId);
    //check if user accepted legals?

    if (hasLoggedInUser) {
      var legalAccepted =
          await _userService.hasUserAcceptedLegals(currentUser!.documentId!);
      if (legalAccepted) {
        if (super.isAdmin) {
          var result = await _authenticationService.getBusinessByEmail();
          if (result is String) {
            await _dialogService.showDialog(
              title: 'Business Setup Error!',
              description: result,
            );
            //_authenticationService.signOff();
          } else {
            if (result is Business) {
              _authenticationService.setCurrentBusiness(result);
            }
            print(hasLoggedInUser);
          }
          if (currentBusiness != null) {
            _navigationService.navigateTo(CourseViewListRoute);
          } else {
            _navigationService.navigateTo(CreateBusinessViewRoute);
          }
        } else if (super.isSystemAdmin) {
          _navigationService.navigateTo(SystemProfileViewRoute);
        } else if (super.isConsumerUser) {
          _navigationService.navigateTo(CourseViewListRoute);
        }
      } else {
        _navigationService.navigateTo(AcceptLegalViewRoute);
      }
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}
