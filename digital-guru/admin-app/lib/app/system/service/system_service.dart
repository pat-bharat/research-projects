import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/model/publication.dart';
import 'package:digiguru/app/common/model/user_count.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/startup/model/user_accepted_legal.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/model/system_profile.dart';
import 'package:digiguru/app/user/model/user_module.dart';

class SystemService extends BaseService {
  final CollectionReference _legalCollectionReference =
      FirebaseFirestore.instance.collection('legals');
  final CollectionReference _systemProfileCollectionReference =
      FirebaseFirestore.instance.collection('system_profile');
  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
  final CollectionReference _businessLegalCollectionReference =
      FirebaseFirestore.instance.collection('business_legals');
  final CollectionReference _businessSettingsCollectionReference =
      FirebaseFirestore.instance.collection('business_settings');
  final CollectionReference _businessCollectionReference =
      FirebaseFirestore.instance.collection('businesses');
  final CollectionReference _userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _courseCollectionReference =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _moduleCollectionReference =
      FirebaseFirestore.instance.collection('modules');
  final CollectionReference _lessonCollectionReference =
      FirebaseFirestore.instance.collection('lessons');
  final CollectionReference _userModuleCollectionReference =
      FirebaseFirestore.instance.collection('user_modules');
  final CollectionReference _userAcceptedLegalsCollectionReference =
      FirebaseFirestore.instance.collection('user_accepted_legals');

  Future loadBusinesOnlyLegals() async {
    try {
      List<SystemLegal> legals = new List.empty(growable: true);
      var userData = await _legalCollectionReference
          .where("legal_type", isEqualTo: "business")
          .get();

      userData.docs.forEach((legal) =>
          legals.add(SystemLegal.fromJson(legal.id, legal.data() as Map<String, dynamic>)));
      return legals;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getConsumerOnlyLegals() async {
    try {
      List<SystemLegal> legals = new List.empty(growable: true);
      var userData = await _legalCollectionReference
          .where("legal_type", isEqualTo: LegalFor.consumer)
          .get();

      userData.docs.forEach((legal) =>
          legals.add(SystemLegal.fromJson(legal.id, legal.data() as Map<String, dynamic>)));
      return legals;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessOnlyLegals() async {
    try {
      List<SystemLegal> legals = new List.empty(growable: true);
      await _legalCollectionReference
          .where('user_type', isEqualTo: LegalFor.business)
          .get()
          .then((snapshot) => {
                snapshot.docs.forEach((legal) =>
                    {legals.add(SystemLegal.fromJson(legal.id, legal.data() as Map<String, dynamic>))})
              });

      return legals;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future deleteSystemLegal(SystemLegal legal) async {
    return _legalCollectionReference.doc(legal.documentId).delete();
  }

  Future updateBusinessSettings(BusinessSetting businessSetting) async {
    try {
      await _businessSettingsCollectionReference
          .doc(businessSetting.documentId)
          .update(businessSetting.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessSettings(String businessId) async {
    BusinessSetting bSetting = BusinessSetting();
    try {
      await _businessSettingsCollectionReference
          .where("business_id", isEqualTo: businessId)
          .get()
          .then((snapshot) => bSetting = BusinessSetting.fromJson(
              snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>));
      return bSetting;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getSystemProfile() async {
    SystemProfile? profile;;
    await _systemProfileCollectionReference.get().then((snapshot) => {
          if (snapshot.docs.isNotEmpty)
            {
              profile = SystemProfile.fromJson(
                  snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>)
            }
        });
    return profile;
  }
  /*
    SystemProfile profile = new SystemProfile();
    int courseCount = await _courseCollectionReference.snapshots().length;
    int moduleCount = await _moduleCollectionReference.snapshots().length;
    int lessonCount = await _lessonCollectionReference.snapshots().length;
    int businessCount = await _businessCollectionReference.snapshots().length;
    int purchasedCounts =
        await _userModuleCollectionReference.snapshots().length;
    Publication publication = Publication(
      courseCounts: courseCount,
      moduleCounts: moduleCount,
      lessonCounts: lessonCount,
      businessCounts: businessCount,
    );
    int adminCount = await _userCollectionReference
        .where("user_role", isEqualTo: UserRole.admin)
        .snapshots()
        .length;
    int consumerCount = await _userCollectionReference
        .where("user_role", isEqualTo: UserRole.user)
        .snapshots()
        .length;

    UserCount userCounts =
        UserCount(adminUsers: adminCount, consumerUsers: consumerCount);
    await _systemProfileCollectionReference.get().then((snapshot) => {
          if (snapshot != null && snapshot.docs.isNotEmpty)
            {
              profile = SystemProfile.fromJson(
                  snapshot.docs.first.data(), publication, userCounts)
            }
        });
    return profile;*/

  Future getAllBusinessesList() async {
    List<Business> businessList = List.empty(growable: true);

    await _businessCollectionReference
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              businessList.add(Business.fromJson(doc.data() as Map<String, dynamic>, doc.id));
            }));
    return businessList;
  }

  Future getBusinessProfile(String bid) async {
    BusinessProfile? profile;
    await _businessProfileCollectionReference
        .where("business_id", isEqualTo: bid)
        .get()
        .then((snapshot) async => {
              if (snapshot.docs.isNotEmpty)
                {
                  profile = BusinessProfile.fromJson(
                      snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>),
                  await getBusinessSettings(bid)
                      .then((value) => profile!.businessSetting = value)
                }
            });
    return profile;
  }

  Future saveUserAcceptedLegals(List legals) async {
    try {
      assert(legals != null);
      legals.forEach((l) async {
        UserAcceptedLegal ual = UserAcceptedLegal(
            userId: BaseService.currentUser?.documentId ?? '',
            acceptedBy: BaseService.currentUser?.email ?? '',
            legalType: l.legalType,
            pdfDoc: l.pdfDoc,
            acceptedTimestamp: DateTime.now().toIso8601String());
        await _userAcceptedLegalsCollectionReference.add(ual.toJson());
      });
    } catch (e) {
      handleException(e as Exception);
    }
  }
  /* Map<String, BusinessProfile> profileMap = {};
    Map<String, UserCount> userCountMap = {};
    Map<String, BusinessSetting> businessSettingMap = {};
    Map<String, Publication> businessPublicationStatsMap = {};
    Business bus;
    BusinessProfile profile;
    await _businessCollectionReference
        .doc(bid)
        .get()
        .then((snap) => {bus = Business.fromJson(snap.data(), snap.id)});
    if (bus != null) {
      //publications
      int adminCount = await _userCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.admin)
          .snapshots()
          .length;
      int consumerCount = await _userCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.user)
          .snapshots()
          .length;
      UserCount userCounts =
          UserCount(adminUsers: adminCount, consumerUsers: consumerCount);
      //settings
      int courseCount = await _courseCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int moduleCount = await _moduleCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int lessonCount = await _lessonCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      Publication publication = Publication(
          courseCounts: courseCount,
          moduleCounts: moduleCount,
          lessonCounts: lessonCount);
      //settings
      BusinessSetting setting = BusinessSetting();
      await _businessSettingsCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                setting = BusinessSetting.fromJson(
                    snap.docs.first.id, snap.docs.first.data())
              });
      //legals
      List<BusinessLegal> businessLegalList = [];
      await _businessLegalCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                snap.docs.forEach((legal) {
                  businessLegalList
                      .add(BusinessLegal.fromJson(legal.id, legal.data()));
                })
              });
      //totalRevenue
      double revenue = 0.0;
      await _userModuleCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                snap.docs.forEach((doc) {
                  UserModule um = UserModule.fromJson(doc.id, doc.data());
                  revenue = revenue + um.purchaseAmount;
                })
              });

      profile = BusinessProfile(
        businessId: bus.documentId,
        businessName: bus.name,
        businessEmail: bus.emailId,
        businessPhone: bus.mobilePhone,
        locked: bus.locked,
        createdTimestamp: bus.createdTimestamp,
        userCount: userCounts,
        publication: publication,
        businessSetting: setting,
        businessLegal: businessLegalList,
      );
      return profile;
    }

    //now fill rest
    userCountMap = getAllUserCountsMap(profileMap);
    businessSettingMap = getAllBusinessSettingMap(profileMap);
    businessPublicationStatsMap = getAllBusinessPublicationStatmap(profileMap);
    // now rearrangemap as bid:BusinessProfile
    profileMap.forEach((bid, profile) {
      profile.userCount = userCountMap.remove(bid);
      profile.businessSetting = businessSettingMap.remove(bid);
      profile.publication = businessPublicationStatsMap.remove(bid);
    });

    return profileMap;*/
/*
  Future getAllBusinessProfileMap() async {
    Map<String, BusinessProfile> profileMap = {};
    Map<String, UserCount> userCountMap = {};
    Map<String, BusinessSetting> businessSettingMap = {};
    Map<String, Publication> businessPublicationStatsMap = {};
    _businessCollectionReference.orderBy("name").get().then((snap) => {
          snap.docs.forEach((business) {
            Business bus = Business.fromJson(business.data(), business.id);
            profileMap.putIfAbsent(
                business.id,
                () => BusinessProfile(
                    businessId: bus.documentId,
                    businessName: bus.name,
                    businessEmail: bus.emailId,
                    businessPhone: bus.mobilePhone,
                    locked: bus.locked,
                    createdTimestamp: bus.createdTimestamp));
          })
        });
    //now fill rest
    userCountMap = getAllUserCountsMap(profileMap);
    businessSettingMap = getAllBusinessSettingMap(profileMap);
    businessPublicationStatsMap = getAllBusinessPublicationStatmap(profileMap);
    // now rearrangemap as bid:BusinessProfile
    profileMap.forEach((bid, profile) {
      profile.userCount = userCountMap.remove(bid);
      profile.businessSetting = businessSettingMap.remove(bid);
      profile.publication = businessPublicationStatsMap.remove(bid);
    });

    return profileMap;
  }

  Map<String, dynamic> getAllBusinessPublicationStatmap(
      Map<String, BusinessProfile> profileMap) {
    //course counts, course counts,
    Map<String, Publication> publicationMap = {};
    profileMap.keys.forEach((bid) async {
      int courseCount = await _courseCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int moduleCount = await _moduleCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int lessonCount = await _lessonCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      publicationMap.putIfAbsent(
          bid,
          () => Publication(
              courseCounts: courseCount,
              totalModuleCounts: moduleCount,
              lessonCounts: lessonCount));
    });
    return publicationMap;
  }

  Map<String, BusinessSetting> getAllBusinessSettingMap(
      Map<String, BusinessProfile> profileMap) {
    Map<String, BusinessSetting> settingsMap = {};
    profileMap.keys.forEach((bid) async {
      BusinessSetting bs;
      await _businessSettingsCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                settingsMap.putIfAbsent(
                    bid,
                    () => BusinessSetting.fromJson(
                        snap.docs.first.id, snap.docs.first.data()))
              });
    });
    return settingsMap;
  }

  Map<String, UserCount> getAllUserCountsMap(
      Map<String, BusinessProfile> profileMap) {
    Map<String, UserCount> userCountMap = {};
    profileMap.keys.forEach((bid) async {
      int adminCount = await _userCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.admin)
          .snapshots()
          .length;
      int consumerCount = await _userCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.user)
          .snapshots()
          .length;
      userCountMap.putIfAbsent(
          bid,
          () =>
              UserCount(adminUsers: adminCount, consumerUsers: consumerCount));
    });
    return userCountMap;
  }*/
}
