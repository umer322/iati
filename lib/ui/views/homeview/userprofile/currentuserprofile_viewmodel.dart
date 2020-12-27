import 'package:flutter/cupertino.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/post_views/post_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CurrentUserProfileViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  final FirestoreService _firestoreService=locator<FirestoreService>();
  final AuthService _authServices = locator<AuthService>();
  logOut(){
    _authServices.logOut();
    _navigationService.clearStackAndShow(authOptions);
  }
  List<Post> _userPosts;
  List<Post> get userPosts=>_userPosts;

  AppUser get currentUser=>_authServices.currentUser;
  void listenToCurrentUserPosts(){
    print("coming here yes");
    setBusy(true);
    if(_userPosts==null){
     callData();
    }
    else{
      if(_userPosts.length>0){
        if(_userPosts.first.userId!=currentUser.id){
            callData();
        }
      }else{
        callData();
      }
    }
  }


  callData(){
    print("coming here for posts update");
    print(currentUser.id);
    _firestoreService.listenToCurrentUserPosts(userId: currentUser.id).listen((posts) {
      List<Post> updatedPosts=posts;
      if(updatedPosts!=null){
        print(updatedPosts);
        _userPosts=updatedPosts;
        notifyListeners();
      }
      setBusy(false);
    });
  }
  void requestMoreCurrentUserData() => _firestoreService.requestMoreCurrentUserData(userId: currentUser.id);

  goToPostPreview({@required Post post}){
    _navigationService.navigateToView(PostView(post: post,));
  }
  deletePost(String id){
    _firestoreService.deletePost(postId:id);
//      #Todo delete images from backend
  }
}