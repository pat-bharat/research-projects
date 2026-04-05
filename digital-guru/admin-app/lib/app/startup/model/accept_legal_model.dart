import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/shared_services/dynamic_link_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/shared_services/push_notification_service.dart';
import 'package:digiguru/app/shared_services/remote_config_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/system/service/system_service.dart';

class AcceptLegalModel extends BaseModel {
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
  final BusinessService _businessService = locator<BusinessService>();
  final SystemService _systemService = locator<SystemService>();

  List<dynamic> _legals = List.empty(growable: true);
  List<dynamic> get legals => _legals;

  AcceptLegalModel();

  Future getLegalList() async {
    //check isAdmin

    if (super.isAdmin) {
      return _legals = await _systemService.getBusinessOnlyLegals();
    } else {
      return _legals = await _businessService
          .getAllBusinessLegals(currentBusiness.documentId!);
    }
  }

  void legalAccepted() async {
    var result = await _systemService.saveUserAcceptedLegals(_legals);
    _navigationService.navigateTo(StartUpViewRoute, arguments: appConfig);
  }

  void legalCancelled() {
    _navigationService.navigateTo(LoginViewRoute);
  }
}
