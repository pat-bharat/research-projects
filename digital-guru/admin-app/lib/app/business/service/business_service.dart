import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/constants/erors.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/model/publication.dart';
import 'package:digiguru/app/common/model/user_count.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/system/model/business_setting.dart';

import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/service/system_service.dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/video/service/download_service.dart';
import 'package:flutter/services.dart';

class BusinessService extends BaseService {
  final CollectionReference _businessesCollectionReference =
      FirebaseFirestore.instance.collection('businesses');
  final CollectionReference _businessesLegalCollectionReference =
      FirebaseFirestore.instance.collection('business_legals');
  final CollectionReference _instructorCollectionReference =
      FirebaseFirestore.instance.collection('instructors');
  final CollectionReference _coursesCollectionReference =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _modulesCollectionReference =
      FirebaseFirestore.instance.collection('modules');
  final CollectionReference _lessonsCollectionReference =
      FirebaseFirestore.instance.collection('lessons');
  final CollectionReference _userModuleCollectionReference =
      FirebaseFirestore.instance.collection('user_modules');
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _businessSettingsCollectionReference =
      FirebaseFirestore.instance.collection('business_settings');
  final CollectionReference _businessLegalsCollectionReference =
      FirebaseFirestore.instance.collection('business_legals');
  final CollectionReference _businessProfileCollectionReference =
      FirebaseFirestore.instance.collection('business_profile');
  final StreamController<List<Business>> _businessController =
      StreamController<List<Business>>.broadcast();
  final StreamController<List<BusinessLegal>> _businessLegalController =
      StreamController<List<BusinessLegal>>.broadcast();
  final SystemService _systemService = locator<SystemService>();
  final DownloadService _downloadService = locator<DownloadService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  // #6: Create a list that will keep the paged results
  List<List<Business>> _allPagedResults = List.empty(growable: true);

  static const int PostsLimit = 20;

  late DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future getBusines(String id) async {
    try {
      var userData = await _businessesCollectionReference.doc(id).get();
      return new Business.fromJson(userData.data() as Map<String, dynamic>, id);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessByEmail(String email) async {
    try {
      var userData = await _businessesCollectionReference
          .where("email_id", isEqualTo: email)
          .get();
      if (userData.docs.isEmpty) {
        return (Strings.noBusinessFoudForEmail + '[' + email + ']');
      } else if (userData.docs.length > 1) {
        return (Strings.multipleBusinessFoundError +
            " [" +
            email +
            "]\n" +
            Strings.contactSystemAdmin);
      } else {
        return new Business.fromJson(
            userData.docs.single.data() as Map<String, dynamic>, userData.docs.single.id);
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getAllActiveBusinesses() async {
    try {
      List<Business> businesses = new List.empty(growable: true);
      await _businessesCollectionReference
          .where("locked", isEqualTo: false)
          .where("deleted", isEqualTo: false)
          .orderBy("name")
          .get()
          .then((value) => {
                value.docs.forEach((business) => businesses
                    .add(Business.fromJson(business.data() as Map<String, dynamic>, business.id)))
              });
      return businesses;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getAllBusinesses() async {
    try {
      List<Business> businesses = new List.empty(growable: true);
      await _businessesCollectionReference
          .orderBy("name")
          .get()
          .then((value) => {
                value.docs.forEach((business) => businesses
                    .add(Business.fromJson(business.data() as Map<String, dynamic>, business.id)))
              });
      return businesses;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future addBusiness(Business business) async {
    try {
      super.populateCommonFields(object: business, created: true);
      var result = await _businessesCollectionReference.add(business.toJson());
      //add business legals
      List<SystemLegal> consLegals =
          await _systemService.getConsumerOnlyLegals();
      consLegals.forEach((legal) async {
        await _downloadService.requestDownload(legal.pdfDoc!, legal.title);
        String toUpload = business.documentId! +
            "/legals/" +
            _downloadService.localDir +
            Platform.pathSeparator +
            legal.title;

        CloudStorageResult storageResult =
            await _cloudStorageService.uploadFile(
          fileToUpload: File(toUpload),
          title: toUpload,
        );

        //add business legal
        await addBusinessLegal(
            business,
            BusinessLegal(
                businessId: business.documentId!,
                legalId: legal.documentId!,
                pdfDoc: storageResult.mediaUrl,
                title: legal.title));
              //now add default besiness settings
        BusinessSetting settings = BusinessSetting(businessId: result.id);
        populateCommonFields(object: settings, created: true);
        await _businessSettingsCollectionReference.add(settings.toJson());
        //now add businessProfile
        BusinessProfile profile = BusinessProfile(
            businessId: result.id,
            userCounts: UserCount(adminUsers: 1),
            publication: Publication());
        await _businessProfileCollectionReference.add(profile.toJson());
      });
        } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessesOnceOff() async {
    try {
      var postDocumentSnapshot =
          await _businessesCollectionReference.limit(PostsLimit).get();
      if (postDocumentSnapshot.docs.isNotEmpty) {
        return postDocumentSnapshot.docs
            .map((snapshot) => Business.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Stream listenToBusinessesRealTime() {
    // Register the handler for when the posts data changes
    _requestBusinesses();
    return _businessController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestBusinesses() {
    // #2: split the query from the actual subscription
    var pageBusinessesQuery = _businessesCollectionReference
        .orderBy('name')
        // #3: Limit the amount of results
        .limit(PostsLimit);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pageBusinessesQuery =
          pageBusinessesQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMorePosts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pageBusinessesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var businesses = snapshot.docs
            .map((snapshot) => Business.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id))
            .where((mappedItem) => mappedItem.name != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = businesses;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(businesses);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<Business>>(
            List<Business>.empty(growable: true),
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all posts
        _businessController.add(allPosts);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = snapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = businesses.length == PostsLimit;
      }
    });
  }

  Future deleteBusiness(Business business) async {
    super.populateCommonFields(object: business, deleted: true);
    await _businessesCollectionReference
        .doc(business.documentId)
        .update(business.toJson());
  }

  Future updateBusiness(String bid, Business business) async {
    try {
      await _businessesCollectionReference.doc(bid).update(business.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  void requestMoreData() => _requestBusinesses();

  Future getAllInstructors(String businessId) async {
    try {
      List<String> instructors = new List.empty(growable: true);
      var userData = await _instructorCollectionReference
          .where("business_id", isEqualTo: businessId)
          .get();
      userData.docs.forEach((instructor) =>
            instructors.add(
                Instructor.fromJson(docId: instructor.id, json: instructor.data() as Map<String, dynamic>).fullName!)
          );
      return instructors;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getAllBusinessLegals(String businessId) async {
    try {
      List<BusinessLegal> legals = new List.empty(growable: true);
      var userData = await _businessesLegalCollectionReference
          .where("business_id", isEqualTo: businessId)
          .get();
      userData.docs.forEach((legal) {legals.add(BusinessLegal.fromJson(legal.id, legal.data() as Map<String, dynamic>));});
      return legals;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future deleteBusinessLegal(BusinessLegal bl) async {
    return await _businessesLegalCollectionReference
        .doc(bl.documentId)
        .delete();
  }

  Stream listenToBusinessLegalRealTime(String documentId) {
    _requestBusinessesLegals(documentId);
    return _businessLegalController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestBusinessesLegals(String businessId) {
    // #2: split the query from the actual subscription
    var pageBusinessesQuery = _businessesLegalCollectionReference
        .where("business_id", isEqualTo: businessId);

    // #5: If we have a document start the query after it
    // #7: Get and store the page index that the results belong to

    pageBusinessesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var businessLegal = snapshot.docs
            .map((snapshot) =>
                BusinessLegal.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
        _businessLegalController.add(businessLegal);
      }
    });
  }

  Future updateBusinessLegal(
      String bldocId, BusinessLegal businessLegal) async {
    try {
      populateCommonFields(object: businessLegal);
      await _businessesLegalCollectionReference
          .doc(bldocId)
          .update(businessLegal.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future addBusinessLegal(
      Business business, BusinessLegal businessLegal) async {
    try {
      populateCommonFields(object: businessLegal);
      return await _businessesLegalCollectionReference
          .add(businessLegal.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future updateBusinessProfileStats(BusinessProfile profile) async {
    try {
      return await _businessProfileCollectionReference
          .doc(profile.documentId)
          .set(profile.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getBusinessProfile(String bid) async {
    BusinessProfile? profile;
    await _businessProfileCollectionReference
        .where("business_id", isEqualTo: bid)
        .get()
        .then((snapshot) => {
              if (snapshot.docs.isNotEmpty)
                {
                  profile = BusinessProfile.fromJson(
                      snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>),
                }
            });

    if (profile != null) {
      await getAllBusinessLegals(bid)
          .then((value) => profile!.businessLegal = value);

      await getBusinessSettings(bid)
          .then((value) => profile!.businessSetting = value);
    }
    return profile;
    /*
    Map<String, BusinessProfile> profileMap = {};
    Map<String, UserCount> userCountMap = {};
    Map<String, BusinessSetting> businessSettingMap = {};
    Map<String, Publication> businessPublicationStatsMap = {};
    Business bus;
    BusinessProfile profile;
    await _businessesCollectionReference
        .doc(bid)
        .get()
        .then((snap) => {bus = Business.fromJson(snap.data(), snap.id)});
    if (bus != null) {
      //publications
      int adminCount = await _usersCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.admin)
          .snapshots()
          .length;
      int consumerCount = await _usersCollectionReference
          .where("business_id", isEqualTo: bid)
          .where("user_role", isEqualTo: UserRole.user)
          .snapshots()
          .length;
      UserCount userCounts =
          UserCount(adminUsers: adminCount, consumerUsers: consumerCount);

      int courseCount = await _coursesCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int moduleCount = await _modulesCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      int lessonCount = await _lessonsCollectionReference
          .where("business_id", isEqualTo: bid)
          .snapshots()
          .length;
      Publication publication = Publication(
          courseCounts: courseCount,
          totalModuleCounts: moduleCount,
          lessonCounts: lessonCount);
      //settings
      BusinessSetting setting = BusinessSetting();
      await _businessSettingsCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                setting = BusinessSetting.fromJson(
                    snap.docs.first.id, snap.docs.first.data() as Map<String, dynamic>)
              });
      //legals
      List<BusinessLegal> businessLegalList = [];
      await _businessLegalsCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                snap.docs.forEach((legal) {
                  businessLegalList
                      .add(BusinessLegal.fromJson(legal.id, legal.data() as Map<String, dynamic>));
                })
              });
      //totalRevenue
      double revenue = 0.0;
      await _userModuleCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snap) => {
                snap.docs.forEach((doc) {
                  UserModule um = UserModule.fromJson(doc.id, doc.data() as Map<String, dynamic>);
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
        userCounts: userCounts,
        publication: publication,
        businessSetting: setting,
        businessLegal: businessLegalList,
        collectedRevenue: revenue,
      );
      return profile;
    }*/
  }

  Future getBusinessSettings(String bid) async {
    BusinessSetting bSetting = BusinessSetting();
    try {
      await _businessSettingsCollectionReference
          .where("business_id", isEqualTo: bid)
          .get()
          .then((snapshot) => bSetting = BusinessSetting.fromJson(
              snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>));
      return bSetting;
    } catch (e) {
      return handleException(e as Exception);
    }
  }
}
