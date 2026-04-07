import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/user/model/user.dart';
import 'package:digiguru/app/user/service/user_service.dart';

class UserProfileModel extends BaseModel {
  UserService _userService = locator<UserService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  User? loadCurrentUserProfile() {
    return currentUser;
  }

  void updateProfile() {}

  void cancel() {}

  void save(User profile) async {
    setBusy(true);
    var result =
        await _userService.updateUser(profile.documentId ?? '', profile);
    notifyListeners();
    setBusy(false);
    if (result is String) {
      await _dialogService.showDialog(
        title: 'Failed!',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Success!',
        description: 'Profile Successfully updated.',
      );
    }
    _navigationService.pop();
  }
}
