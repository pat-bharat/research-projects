import 'dart:async';

import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/shared_services/analytics_service.dart';
import 'package:digiguru/app/user/service/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService extends BaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? businessId;
  final UserService _userService = locator<UserService>();
  final BusinessService _businessService = locator<BusinessService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future<bool> loginWithEmail(
      {required String email,
      required String password,
      String? businessId}) async {
    this.businessId = businessId;
    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      return response.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
    required String businessId,
  }) async {
    this.businessId = businessId;
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      return response.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUpWithGoogle(
      {required String role, String? businessId}) async {
    this.businessId = businessId;

    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = 'my-web.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn signIn = GoogleSignIn.instance;

    // At the start of your app, initialize the GoogleSignIn instance
    unawaited(
        signIn.initialize(clientId: iosClientId, serverClientId: webClientId));

    // Perform the sign in
    final googleAccount = await signIn.authenticate();
    final googleAuthorization =
        await googleAccount.authorizationClient.authorizationForScopes([]);
    final googleAuthentication = googleAccount.authentication;
    final idToken = googleAuthentication.idToken;
    final accessToken = googleAuthorization!.accessToken;

    if (idToken == null) {
      throw 'No ID Token found.';
    }

    var response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    return response.user != null;
  }

  Future<bool> signOut() async {
    try {
      await _supabase.auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserLoggedIn({required String businessId}) async {
    final user = _supabase.auth.currentUser;
    this.businessId = businessId;
    if (user != null) {
      await _populateCurrentUser(user);
      await _populateCurrentBusiness(user);
    }
    return user != null;
  }

  Future<bool> sendPasswordEmail({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future _populateCurrentUser(User supabaseUser) async {
    BaseService.currentUserToken = (await supabaseUser.id);
    BaseService.currentUser = await _userService.getUser(supabaseUser.id);
    BaseService.currentFirebaseUser = supabaseUser;
    await _analyticsService.setUserProperties(
      userId: BaseService.currentFirebaseUser!.id,
      userRole: BaseService.currentUser!.userRole ?? '',
    );
  }

  Future getBusinessByEmail() async {
    if (BaseService.currentUser != null) {
      if (BaseService.currentUser!.userRole == "Admin") {
        if (BaseService.currentUser!.email != null) {
          return await _businessService
              .getBusinessByEmail(BaseService.currentUser!.email!);
        }
      }
      //TODo analytics
    }
  }

  Future _populateCurrentBusiness(User user) async {
    if (BaseService.currentUser!.userRole == UserRole.admin) {
      if (user.email != null) {
        BaseService.currentBusiness =
            await _businessService.getBusinessByEmail(user.email!);
      }
    } else if (BaseService.currentUser!.userRole == UserRole.user) {
      BaseService.currentBusiness = Business();
      BaseService.currentBusiness.id = businessId!;
    }
    //TODo analytics
  }

  void _updateUserCount(String businessId, bool isAdmin) async {
    BusinessProfile profile =
        await _businessService.getBusinessProfile(businessId);
    if (isAdmin) {
      profile.userCounts!.adminUsers =
          (profile.userCounts?.adminUsers ?? 0) + 1;
    } else {
      profile.userCounts!.consumerUsers =
          (profile.userCounts?.consumerUsers ?? 0) + 1;
    }
    await BaseService.supabaseDataService
        .update("business_profile", profile.id, profile.toJson());
  }

  Future<Object?> signUpWithFacebook({required String role}) async {
    return "";
  }
}
