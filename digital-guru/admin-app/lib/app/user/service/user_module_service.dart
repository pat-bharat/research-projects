import 'dart:async';
import 'dart:collection';

import 'package:digiguru/app/business/model/business_profille.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/user/model/user_module.dart';

class UserModuleService extends BaseService {
  BusinessService _businessService = locator<BusinessService>();
  LessonService _lessonService = locator<LessonService>();
  final StreamController<List<UserModule>> _purchasedUserModuleController =
      StreamController<List<UserModule>>.broadcast();
  final StreamController<List<UserModule>> _trialUserModuleController =
      StreamController<List<UserModule>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<UserModule>> _allPagedResults = List.empty(growable: true);

  static const int PostsLimit = 20;

  late Map<String, dynamic> _lastDocument;

  Future addUserModule(UserModule userModule) async {
    try {
      //check if it is already purchased?
      if (userModule.id == null) {
        return "Invalid module ID";
      }
      var purchased = await isModuleAlreadyPurchased(userModule.id!);
      if (purchased is bool && !purchased) {
        var result = await BaseService.supabaseDataService
            .insert('user_modules', userModule.toJson());
        BusinessProfile bProfile = await _businessService
            .getBusinessProfile(BaseService.currentBusiness.id!);
        bProfile.userCounts?.purchasedUsers =
            (bProfile.userCounts?.purchasedUsers ?? 0) + 1;
        bProfile.collectedRevenue = ((bProfile.collectedRevenue ?? 0) +
            (userModule.purchaseAmount ?? 0));
        bProfile.publication?.purchasedModuleCounts =
            (bProfile.publication?.purchasedModuleCounts ?? 0) + 1;
        await _businessService.updateBusinessProfileStats(bProfile);
        return result;
      } else {
        return "Already Purchased!";
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future isModuleAlreadyPurchased(String moduleId) async {
    try {
      //check if it is already purchased?
      bool purchased = false;
      await BaseService.supabaseDataService
          .fetchAllWithQuery('user_modules', where: {
        'module_id': moduleId
      }).then((value) => {
                if (value.isNotEmpty) {purchased = true}
              });
      /*await _userModulesCollectionReference   
          .where("module_id", isEqualTo: moduleId)
          .get()
          .then((value) {
        if (value != null && value.docs.isNotEmpty) {
          purchased = true;
        }
      });
      */
      return purchased;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getUserModule(String uid) async {
    try {
      var userData =
          await BaseService.supabaseDataService.fetchById('user_modules', uid);
      return UserModule.fromJson(uid, userData as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /*
Future getFreeUserModules() async {
    List<Course> courseList = List.empty(growable: true);
    List<UserModule> userModuleList = List.empty(growable: true);

    try {
      await _courseService
          .getBusinessCourses(BaseService.currentBusiness.documentId)
          .then((value) => {courseList = value});

      courseList.forEach((c) async {
        await _moduleService
            .allCourseModules(c.documentId)
            .then((modulesList) => {
                  modulesList.forEach((module) async {
                    List<String> lessonIdList = List.empty(growable: true);
                    List<Lesson> lessonList = List.empty(growable: true);
                    bool foundFreeLesson = false;
                    //iterate lessons for each module
                    await _lessonService
                        .getAllFreeModuleLessons(module.documentId)
                        .then((lessons) => {
                              lessons.forEach((lesson) {
                                foundFreeLesson = true;
                                lessonIdList.add(lesson.documentId);
                                lessonList.add(lesson);
                              }),
                              if (foundFreeLesson)
                                {
                                  userModuleList.add(UserModule(
                                      userId:
                                          BaseService.currentUser.doocumetnId,
                                      courseInfo: CourseInfo(
                                          courseId: c.documentId,
                                          courseName: c.title,
                                          instructorName: c.instructorName),
                                      moduleInfo: ModuleInfo(
                                          moduleId: module.documentId,
                                          moduleName: module.name,
                                          moduleTitle: module.title,
                                          lessons: lessonIdList,
                                          lessonList: lessonList)))
                                }
                            });
                  })
                });
      });
      return userModuleList;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }*/

  Stream listenToTrialUserModuleRealTime(String doocumetnId) {
    getFreeUserModules();

    return _trialUserModuleController.stream;
  }

  void getFreeUserModules() async {
    List<Lesson> lessonList = List.empty(growable: true);
    List<UserModule> userModuleList = List.empty(growable: true);
    try {
      await _lessonService
          .getAllBusinessFreeLessons()
          .then((lessons) => {lessonList.addAll(lessons)});
      // List<String> courseList = List.empty(growable: true);
      Map<String, UserModule> map = HashMap<String, UserModule>();
      lessonList.forEach((l) {
        {
          if (map.containsKey(l.moduleTitle)) {
            UserModule? um = map.remove(l.moduleTitle);
            um!.lessonIds!.add(l.id!);
            um.lessons!.add(l);
            map.putIfAbsent(l.moduleTitle!, () => um);
          } else {
            map.putIfAbsent(
                l.moduleTitle!,
                () => UserModule(
                    userId: BaseService.currentUser?.documentId,
                    courseId: l.courseId,
                    courseName: l.courseTitle,
                    instructorName: l.instructorName,
                    moduleId: l.moduleId,
                    moduleTitle: l.moduleTitle,
                    lessonIds: [l.id!],
                    lessons: [l]));
          }
        }
      });
      userModuleList.addAll(map.values);
      _trialUserModuleController.add(userModuleList);
    } catch (e) {
      handleException(e as Exception);
    }
  }

  Stream listenToPurchasedUserModuleRealTime(String useId) {
    // Register the handler for when the posts data changes
    _requestPurchasedUserModules(useId);
    return _purchasedUserModuleController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestPurchasedUserModules(String userId) async {
    // #2: split the query from the actual subscription
    var userModuleListQuery = BaseService.supabaseDataService
        .fetchAllWithQuery('user_modules', where: {'user_id': userId});
    // List<UserModule> userModules = List.empty(growable: true);
    List<UserModule> finalUserModules = List.empty(growable: true);
    userModuleListQuery.asStream().listen((userModuleSnapshot) {
      if (userModuleSnapshot.isNotEmpty) {
        userModuleSnapshot
            .map((snapshot) => UserModule.fromJson(
                snapshot['id'] as String, snapshot))
            .where((mappedItem) => mappedItem.userId != null)
            .toList()
            .forEach((um) {
          um.lessons = List.empty(growable: true);
          _populateModuleLessons(um);
          finalUserModules.add(um);
        });

        // now add lessons;
        /*  userModules.forEach((um) {
          List<Lesson> lessons = List.empty(growable: true);
          um.lessons = List.empty(growable: true);
          _lessonService
              .getModuleLessons(um.moduleId)
              .then((lsns) => lessons.addAll(lsns));
          if (um.lessons != null) {
            um.lessons.addAll(lessons);
          }
          finalUserModules.add(um);
        });*/
        _purchasedUserModuleController.add(finalUserModules);
      }
    });
  }

  Future _populateModuleLessons(UserModule um) async {
    List<Lesson> lessons = List.empty(growable: true);
    await _lessonService
        .getModuleLessons(um.moduleId!)
        .then((lsns) => lessons.addAll(lsns));
    um.lessons!.addAll(lessons);
    return "Success";
  }

  void requestMoreData(String busiessId) =>
      _requestPurchasedUserModules(busiessId);

  Future getAllUserModules(String userId) async {
    try {
      List<UserModule> modules = List.empty(growable: true);
      var result = await BaseService.supabaseDataService
          .fetchAllWithQuery('user_modules', where: {'user_id': userId});
      result.forEach((element) {
        modules.add(UserModule.fromJson(
            element['id'] as String, element));
      });
      return modules;
    } catch (e) {
      return handleException(e as Exception);
    }
  }
}

class ModuleInfo {
  String moduleTitle;
  List<Lesson> lessons = List.empty(growable: true);
  List<String> lessonIds = List.empty(growable: true);
  ModuleInfo(this.moduleTitle, this.lessons, this.lessonIds);
}
