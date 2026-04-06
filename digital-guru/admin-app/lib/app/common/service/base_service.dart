//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/constants/erors.dart';
import 'package:digiguru/app/shared_services/supabase_data_service.dart';
import 'package:digiguru/app/user/model/user.dart' as u;
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class BaseService {
  static u.User? currentUser;
  static String currentUserToken = "";
  String _baseUploadUrl =
      "https://firebasestorage.googleapis.com/v0/b/digital-guru-bharat.appspot.com/o/";
//https://firebasestorage.googleapis.com/v0/b/digital-guru-bharat.appspot.com/o/oAq9WHcJ5DdTmwJZfjaq%2FVVTrcNkacIEaDf4Dccs5%2FygVBOpcWuo5pgLUivUZZ%2FnamxXGTs1HWjXjCwAntt%2FVID-20201001-WA0000.jpg?alt=media&token=75c936f4-7f20-4be4-a13f-d646196df586
  static User? currentFirebaseUser;

  static bool isPreviewAsUser = false;
  static final supabaseDataService = SupabaseDataService();
   

  String get baseUploadUrl => _baseUploadUrl;
  static late Business currentBusiness;
  // Business get currentBusiness => _currentBusiness;
  // u.User get currentUser => _currentUser;
  // u.User get currentUser => _currentUser;

  static bool isAdmin() {
    return currentUser != null && currentUser!.userRole == "Admin";
  }

  static bool isSystemAdmin() {
    return currentUser != null && currentUser!.userRole == "System";
  }

  static bool isConsumnerUser() {
    return currentUser != null && currentUser!.userRole == "User";
  }

  void setCurrentBusiness(Business business) {
    currentBusiness = business;
  }

  void setCurrentUser(u.User user) {
    currentUser = user;
  }

  void populateCommonFields(
      {required dynamic object, bool? created, bool? deleted}) {
    object.modifiedBy = currentUser != null ? currentUser!.email : "";
    if (created != null && created) {
      object.createdTimestamp = DateTime.now().toIso8601String();
    }
    if (deleted != null && deleted) {
      object.deletedTimestamp = DateTime.now().toIso8601String();
      if (object.deleted != null) object.deleted = true;
    }
    object.updatedTimestamp = DateTime.now().toIso8601String();
  }

  String handleException(Exception e, {String? msg, List? data}) {
    //TODO implement this
    if (msg == null) {
      msg = Errors.persistanceError;
    }
    print(e);
    return msg;
  }

  Future<bool> isWifiConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> isMobileDataConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile;
  }

  Future<bool> isOffline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.none;
  }
}
