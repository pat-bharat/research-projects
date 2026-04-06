//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/module/service/module_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/purchase/service/purchase_service.dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/user/service/user_module_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

class ModuleListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ModuleService _moduleService = locator<ModuleService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final PurchaseService _purchaseService = locator<PurchaseService>();
  final UserModuleService _userModuleService = locator<UserModuleService>();

  List<Module> _modules = List<Module>.empty(growable: true);

  late Course _course;
  Course get course => _course;
  List<Module> get modules => _modules;

  ModuleListModel({required Course course}) {
    this._course = course;
  }
  void listenToModules() {
    setBusy(true);
    _moduleService.listenToModulesRealTime(_course.id!).listen((module) {
      List<Module> modules = module;
      if (modules.length > 0) {
        _modules = modules;
        // notifyListeners();
      }
      setBusy(false);
    });
  }

  Future deleteModule({required Module module}) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the post?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed!) {
      // var moduleToDelete = _modules[index];
      setBusy(true);
      await _moduleService.deleteModule(module.id);
      // Delete the image after the module is deleted
      if (module.moduleBackground!.imageUrl != null) {
        await _cloudStorageService.deleteFile(module.moduleBackground!.imageUrl!);
      }
      if (module.moduleDetailDoc!.docUrl != null && module.moduleDetailDoc!.docUrl!.isNotEmpty) {
        await _cloudStorageService.deleteFile(module.moduleDetailDoc!.docUrl!);
      }

      if (module.moduleVideo!.videoUrl != null && module.moduleVideo!.videoUrl!.isNotEmpty) {
        await _cloudStorageService.deleteFile(module.moduleVideo!.videoUrl!);
      }

      setBusy(false);
    }
  }

  Future navigateToAddModuleView() async {
    _navigationService.navigateTo(AddUpadateModuleViewRoute,
        arguments: new CourseModuleArgs(course: _course));
  }

  void editModule(Module module) {
    _navigationService.navigateTo(AddUpadateModuleViewRoute,
        arguments: new CourseModuleArgs(course: _course, module: module));
  }

  void editLesons(Module module) {
    _navigationService.navigateTo(LessonViewListRoute,
        arguments: CourseModuleArgs(course: course, module: module));
  }

  void requestMoreData() => _moduleService.requestMoreData(_course.id!);

  void saveModuleDisplayOrder(List<Module> items) async {
    //TODO update in batch
    for (final item in items) {
      int index = items.indexOf(item);
      if (index != item.displayOrder) {
        item.displayOrder = index;
        this._moduleService.updateModule(item.id!, item);
      }
    }
  }

  purchaseModule(Module module) async {
    UserModule userModule = UserModule(
      courseId: course.id!,
      moduleId: module.id,
      courseName: course.title!,
      instructorName: course.instructorName!,
      moduleName: module.name,
      moduleTitle: module.title,
      userId: currentUser!.documentId,
      purchaseAmount: module.discountPercentage! > 0
          ? (module.discountPercentage! * module.purchaseAmount! / 100)
          : module.purchaseAmount!,
      purchaseDate: DateTime.now().toIso8601String(),
    );
    if (!_purchaseService.simulated) {
      _purchaseService.initPurchaseService();
      await _purchaseService.requestPurchase(buildIAPItem(userModule));
    }
    //nowadd to database
    //TODO work on inditify how to detect succful transaction
    var result = await _userModuleService.addUserModule(userModule);
    if (result is Map) {
      _dialogService.showDialog(
          title: "Success!",
          buttonTitle: "Conratulations!",
          description: "Module \n" +
              module.name! +
              '\n' +
              module.title! +
              "\nSuccessfully purchased");
    } else {
      _dialogService.showDialog(
          title: "Failed!",
          buttonTitle: "Try Again!",
          description: module.name! +
              '\n' +
              module.title! +
              "\nFailed!! \n\n" +
              result.toString());
    }
  }

  dynamic buildIAPItem(UserModule module) {
    /*
productId = json['productId'] as String,
        price = json['price'] as String,
        currency = json['currency'] as String,
        localizedPrice = json['localizedPrice'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        introductoryPrice = json['introductoryPrice'] as String,
        introductoryPricePaymentModeIOS =
            json['introductoryPricePaymentModeIOS'] as String,
        introductoryPriceNumberOfPeriodsIOS =
            json['introductoryPriceNumberOfPeriodsIOS'] as String,
        introductoryPriceSubscriptionPeriodIOS =
            json['introductoryPriceSubscriptionPeriodIOS'] as String,
        introductoryPriceNumberIOS = json['introductoryPriceNumberIOS'] as String,
        subscriptionPeriodNumberIOS =
            json['subscriptionPeriodNumberIOS'] as String,
        subscriptionPeriodUnitIOS = json['subscriptionPeriodUnitIOS'] as String,
        subscriptionPeriodAndroid = json['subscriptionPeriodAndroid'] as String,
        introductoryPriceCyclesAndroid =
            json['introductoryPriceCyclesAndroid'] as int,
        introductoryPricePeriodAndroid =
            json['introductoryPricePeriodAndroid'] as String,
        freeTrialPeriodAndroid = json['freeTrialPeriodAndroid'] as String,
        signatureAndroid = json['signatureAndroid'] as String,
        iconUrl = json['iconUrl'] as String,
        originalJson = json['originalJson'] as String,
        originalPrice = json['originalPrice'].toString(),
        discountsIOS = _extractDiscountIOS(json['discounts']);
    */
    String localizedPrice =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(2.99);
    var amount = module.purchaseAmount;
    return {
      'productId': 'digigure_module',
      'price': '$amount',
      'currency': 'USD',
      'localizedPrice': '$localizedPrice',
      'course': '$module.courseName',
      'name': '$module.moduleName',
      'title': '$module.moduleTitle',
      'user': '$module.userId',
    };
  }

  dynamic isModuleAlreadyPurchased(String moduleId) async {
    bool purchased = true;
    var result = await _userModuleService.isModuleAlreadyPurchased(moduleId);
    if (result != null && result is bool) {
      purchased = result;
    } else {
      purchased = false;
    }
    return purchased;
  }

  Future getAllUserPurchasedModules(String userId) async {
    setBusy(true);
    List<String> modules = List.empty(growable: true);
    List<UserModule> userModules =
        await _userModuleService.getAllUserModules(userId);
    userModules.forEach((um) {
      modules.add(um.moduleId!);
    });
    notifyListeners();
    setBusy(false);
    return modules;
  }
}

class CourseModuleArgs {
  Module? module;
  Course course;

  CourseModuleArgs({required this.course, this.module});
}
