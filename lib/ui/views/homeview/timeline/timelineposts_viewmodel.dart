import 'package:flutter/cupertino.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:stacked/stacked.dart';

class TimeLinePostsViewModel extends BaseViewModel{
  final FirestoreService _fireStoreServices=locator<FirestoreService>();
  final AuthService _authService=locator<AuthService>();
  AppUser get currentUser=>_authService.currentUser;

  List<Post> _timeLinePosts;
  List<Post> get timeLinePosts=>_timeLinePosts;

  listenToData(){
    setBusy(true);
    _fireStoreServices.listenToTimeLinePosts(user: currentUser).listen((updatedTimeLinePosts) {
      if(updatedTimeLinePosts!=null){
        print("updating posts");
        _timeLinePosts=updatedTimeLinePosts;
        notifyListeners();
        setBusy(false);
      }
    });

  }

  requestMoreData()=>_fireStoreServices.requestMoreTimeLineData(user: currentUser);
}