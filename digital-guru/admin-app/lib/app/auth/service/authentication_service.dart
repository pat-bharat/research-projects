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

  String businessId;
  Future loginWithEmail(
      {@required String email,
      @required String password,
      String businessId}) async {
    this.businessId = businessId;
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      if (BaseService.currentUser != null) {
        BaseService.currentUser.lastLoginTimestamp =
            DateTime.now().toIso8601String();
        if (businessId != null) {
          BaseService.currentUser.businessId = businessId;
        }
        _userService.updateUser(
            BaseService.currentUser.documentId, BaseService.currentUser);
      }
      await _populateCurrentBusiness(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return handleException(e);
    }
  }

  Future singOut() async {
    try {
      await _firebaseAuth.signOut();
      BaseService.currentUserToken = null;
      BaseService.currentUser = null;
      BaseService.currentBusiness = null;
    } catch (e) {
      return handleException(e);
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
    String businessId,
  }) async {
    this.businessId = businessId;
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore

      u.User _cUser =
          buildNewUser(authResult.user, fullName: fullName, role: role);

      await _userService.createUser(_cUser);
      await _analyticsService.setUserProperties(
        userId: authResult.user.uid,
        userRole: _cUser.userRole,
      );
      BaseService.currentUser = _cUser;
      //update user count
      _updateUserCount(businessId, BaseService.isAdmin());
      return authResult.user != null;
    } catch (e) {
      return handleException(e);
    }
  }

  u.User buildNewUser(User firebaseUser, {String fullName, String role}) {
    return u.User(
        userId: firebaseUser.uid,
        email: firebaseUser.email,
        fullName: fullName != null ? fullName : firebaseUser.displayName,
        userRole: role,
        mobileNo: firebaseUser.phoneNumber,
        profilePic: firebaseUser.photoURL,
        lastLoginTimestamp: DateTime.now().toIso8601String());
  }

  Future signUpWithGoogle({@required String role, String businessId}) async {
     this.businessId = businessId;
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);
      u.User _cUser = buildNewUser(user, role: role);
      await _userService.createUser(_cUser);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: _cUser.userRole,
      );
      BaseService.currentUser = _cUser;
      BaseService.currentFirebaseUser = user;
      //updateUserCount
      _updateUserCount(businessId, BaseService.isAdmin());
      return user != null;
    } catch (e) {
      return handleException(e);
    }
  }

  Future signUpWithFacebook({@required String role}) async {
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

  Future<bool> isUserLoggedIn({String businessId}) async {
    User user = _firebaseAuth.currentUser;
    this.businessId = businessId;
    if (user != null) {
      await _populateCurrentUser(user);
      await _populateCurrentBusiness(user);
    }
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      BaseService.currentUserToken = await user.getIdToken();
      BaseService.currentUser = await _userService.getUser(user.uid);
      BaseService.currentFirebaseUser = user;
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: BaseService.currentUser.userRole,
      );
    }
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
    if (user != null && BaseService.currentUser != null) {
      if (BaseService.currentUser.userRole == UserRole.admin) {
        BaseService.currentBusiness =
            await _businessService.getBusinessByEmail(user.email);
      } else if (BaseService.currentUser.userRole == UserRole.user) {
        BaseService.currentBusiness = Business();
        BaseService.currentBusiness.documentId = businessId;
      }
      //TODo analytics
    }
  }

  void _updateUserCount(String businessId, bool isAdmin) async {
    BusinessProfile profile =
        await _businessService.getBusinessProfile(businessId);
    if (isAdmin) {
      profile.userCounts.adminUsers = profile.userCounts.adminUsers + 1;
    } else {
      profile.userCounts.consumerUsers = profile.userCounts.consumerUsers + 1;
    }

    DocumentReference bpRef =
        _businessProfileCollectionReference.doc(profile.documentId);
    await _businessService.updateBusinessProfileStats(profile);
  }

  Future signOff() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      return handleException(e);
    }
  }

  Future sendPasswordEmail({@required String email}) async {
    if (email != null) {
      try {
        _firebaseAuth.sendPasswordResetEmail(email: email);
      } catch (e) {
        return handleException(e);
      }
    }
  }
}
