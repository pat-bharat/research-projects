import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/firebase_services/service/analytics_service.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/user/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digiguru/app/user/model/user.dart' as u;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends BaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = locator<UserService>();
  final BusinessService _businessService = locator<BusinessService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');

  String? businessId;
  Future loginWithEmail(
      {required String email,
      required String password,
      String? businessId}) async {
    this.businessId = businessId;
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        await _populateCurrentUser(authResult.user!);
      }
      BaseService.currentUser.lastLoginTimestamp =
          DateTime.now().toIso8601String();
      if (businessId != null) {
        BaseService.currentUser.businessId = businessId;
      }
      _userService.updateUser(
          BaseService.currentUser.documentId, BaseService.currentUser);
      if (authResult.user != null) {
        await _populateCurrentBusiness(authResult.user!);
      }
      return authResult.user != null;
    } catch (e) {
      return handleException(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future singOut() async {
    try {
      await _firebaseAuth.signOut();
      BaseService.currentUserToken = "";
      BaseService.currentUser = u.User();
      BaseService.currentBusiness = Business();
    } catch (e) {
      return handleException(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
    required String businessId,
  }) async {
    this.businessId = businessId;
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore

      u.User _cUser =
          buildNewUser(authResult.user!, fullName: fullName, role: role);

      await _userService.createUser(_cUser);
      await _analyticsService.setUserProperties(
        userId: authResult.user!.uid,
        userRole: _cUser.userRole,
      );
      BaseService.currentUser = _cUser;
      //update user count
      _updateUserCount(businessId, BaseService.isAdmin());
      return authResult.user != null;
    } catch (e) {
      return handleException(e is Exception ? e : Exception(e.toString()));
    }
  }

  u.User buildNewUser(User firebaseUser, {required String fullName, required String role}) {
    return u.User(
      userId: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      fullName: fullName.isNotEmpty ? fullName : (firebaseUser.displayName ?? ''),
      userRole: role,
      mobileNo: firebaseUser.phoneNumber ?? '',
      profilePic: firebaseUser.photoURL ?? '',
      lastLoginTimestamp: DateTime.now().toIso8601String());
  }

  Future signUpWithGoogle({required String role,  String? businessId}) async {
    this.businessId = businessId;
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Google sign in failed');
      }
      print("signed in ${user.displayName}");
      u.User _cUser = buildNewUser(user, fullName: user.displayName ?? '', role: role);
      await _userService.createUser(_cUser);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: _cUser.userRole,
      );
      BaseService.currentUser = _cUser;
      BaseService.currentFirebaseUser = user;
      //updateUserCount
      if (businessId != null) {
        _updateUserCount(businessId, BaseService.isAdmin());
      }
      return true;
    } catch (e) {
      return handleException(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future signUpWithFacebook({required String role}) async {
    /*try {
      final AccessToken result = await FacebookAuth.instance.login();
      /*if(result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,

        );*/
      final AuthCredential credential = FacebookAuthProvider.credential(
        result.token,
      );

      final User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      print('signed in ' + user.displayName);
      print("signed in " + user.displayName);
      u.User _cUser = buildUser(user, role);
      await _firestoreService.createUser(_cUser);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: _cUser.userRole,
      );
      BaseService.currentUser = _cUser;
      return user != null;
      // }
    } catch (e) {
      print(e.message);
    }*/
  }

  Future<bool> isUserLoggedIn({required String businessId}) async {
    User? user = _firebaseAuth.currentUser;
    this.businessId = businessId;
    if (user != null) {
      await _populateCurrentUser(user);
      await _populateCurrentBusiness(user);
    }
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    BaseService.currentUserToken = (await user.getIdToken())!;
    BaseService.currentUser = await _userService.getUser(user.uid);
    BaseService.currentFirebaseUser = user;
    await _analyticsService.setUserProperties(
      userId: user.uid,
      userRole: BaseService.currentUser.userRole,
    );
    }

  Future getBusinessByEmail() async {
    if (BaseService.currentUser != null) {
      if (BaseService.currentUser.userRole == "Admin") {
        return await _businessService
            .getBusinessByEmail(BaseService.currentUser.email);
      }
      //TODo analytics
    }
  }

  Future _populateCurrentBusiness(User user) async {
    if (BaseService.currentUser.userRole == UserRole.admin) {
      BaseService.currentBusiness =
          await _businessService.getBusinessByEmail(user.email!);
    } else if (BaseService.currentUser.userRole == UserRole.user) {
      BaseService.currentBusiness = Business();
      BaseService.currentBusiness.documentId = businessId!;
    }
    //TODo analytics
    }

  void _updateUserCount(String businessId, bool isAdmin) async {
    BusinessProfile profile =
        await _businessService.getBusinessProfile(businessId);
    if (isAdmin) {
      profile.userCounts!.adminUsers = (profile.userCounts?.adminUsers ?? 0) + 1;
    } else {
      profile.userCounts!.consumerUsers = (profile.userCounts?.consumerUsers ?? 0) + 1;
    }

    DocumentReference bpRef =
        _businessProfileCollectionReference.doc(profile.documentId);
    await _businessService.updateBusinessProfileStats(profile);
  }

  Future signOff() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      return handleException(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future sendPasswordEmail({required String email}) async {
    if (email != null) {
      try {
        _firebaseAuth.sendPasswordResetEmail(email: email);
      } catch (e) {
        return handleException(e is Exception ? e : Exception(e.toString()));
      }
    }
  }
}
