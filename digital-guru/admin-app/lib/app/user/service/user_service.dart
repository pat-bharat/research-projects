import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/startup/model/user_accepted_legal.dart';
import 'package:digiguru/app/user/model/user.dart';
import 'package:flutter/services.dart';

class UserService extends BaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _userAccepedLegalsCollectionReference =
      FirebaseFirestore.instance.collection('user_accepted_legals');
  final StreamController<List<User>> _postsController =
      StreamController<List<User>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<User>> _allPagedResults = List.empty(growable: true);

  static const int PostsLimit = 20;

 late DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future createUser(User user) async {
    try {
      user.userPreferances = UserPreferances(
          downloadLessons: true,
          inAppNotifications: true,
          wifiDownloadOnly: true);
      populateCommonFields(object: user, created: true);
      await _usersCollectionReference.doc(user.userId).set(user.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return User.fromJson(uid, userData.data() as Map<String, dynamic>);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Future hasUserAcceptedLegals(String uid) async {
    try {
      bool accepted = false;
      QuerySnapshot snapshot = await _userAccepedLegalsCollectionReference
          .where("user_id", isEqualTo: uid)
          .get();
      return snapshot.docs.length == 2;
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  Stream listenToPostsRealTime(String businessId) {
    // Register the handler for when the posts data changes
    _requestPosts(businessId);
    return _postsController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestPosts(String bid) {
    // #2: split the query from the actual subscription
    var pagePostsQuery = _usersCollectionReference
        .where("business_id", isEqualTo: bid)
        .orderBy('fullName')
        // #3: Limit the amount of results
        .limit(PostsLimit);

    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pagePostsQuery = pagePostsQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMorePosts) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pagePostsQuery.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.docs.isNotEmpty) {
        var posts = postsSnapshot.docs
            .map((snapshot) => User.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>))
            .where((mappedItem) => mappedItem.fullName != null)
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = posts;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(posts);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<User>>(<User>[],
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all posts
        _postsController.add(allPosts);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = postsSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = posts.length == PostsLimit;
      }
    });
  }

  Future deleteUser(String documentId) async {
    await _usersCollectionReference.doc(documentId).delete();
    //TODO delete from fireauth
  }

  Future updateUser(String uid, User user) async {
    try {
      BaseService.currentUser = user;
      if (BaseService.isPreviewAsUser)
        BaseService.currentUser?.userRole = UserRole.admin;

      await _usersCollectionReference.doc(uid).update(user.toJson());
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  void requestMoreData(String busiessId) => _requestPosts(busiessId);
}
