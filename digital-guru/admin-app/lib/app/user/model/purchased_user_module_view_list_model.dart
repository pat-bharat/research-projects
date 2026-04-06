import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/tools/data_loader.dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/user/service/user_module_service.dart';

class PurchasedUserModuleListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserModuleService _userModuleService = locator<UserModuleService>();
  final DialogService _dialogService = locator<DialogService>();
  final LessonService _lessonService = locator<LessonService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  List<UserModule> _userModules = List.empty(growable: true);

  List<UserModule> get userModules => _userModules;

  void listenToPurchasedUserModule() async {
    setBusy(true);
    List<UserModule> uModules = List.empty(growable: true);
    _userModuleService
        .listenToPurchasedUserModuleRealTime(currentUser!.documentId!)
        .listen((userModules) {
      uModules = userModules;
      if (uModules.isNotEmpty) {
        //if (uModules.toList().first.lessons.isNotEmpty) {
        _userModules = uModules;
        // notifyListeners();
        // }
      }
      setBusy(false);
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
  Lesson? lesson;

  ModuleLessonsArgs({required this.module, this.lesson});
}
