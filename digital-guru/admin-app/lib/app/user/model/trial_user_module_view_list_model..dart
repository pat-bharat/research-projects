import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/user/service/user_module_service.dart';

class TrialUserModuleListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserModuleService _userModuleService = locator<UserModuleService>();

  List<UserModule> _userModules = List.empty(growable: true);

  List<UserModule> get userModules => _userModules;

  Future listenToFreeUserModule() async {
    setBusy(true);
    _userModuleService
        .listenToTrialUserModuleRealTime(currentUser!.documentId!)
        .listen((userModules) {
      if (userModules != null) {
        _userModules.addAll(userModules);

        notifyListeners();
      } else {
        setBusy(false);
      }
    });
  }

  void requestMoreData() =>
      _userModuleService.requestMoreData(currentBusiness.id!);

  goBack() {
    _navigationService.pop();
  }

  /* Future loadFreeModule() async {
    setBusy(true);
    await _userModuleService
        .getFreeUserModules()
        .then((value) => _userModules = value);

    notifyListeners();

    setBusy(false);
    return _userModules;
  }*/
}

class ModuleLessonsArgs {
  Module module;
  Lesson lesson;

  ModuleLessonsArgs({required this.module, required this.lesson});
}
