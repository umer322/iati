import 'package:flutter/cupertino.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/dynamiclinks_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/post_views/post_view.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserProfileViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  final FirestoreService _firestoreService=locator<FirestoreService>();
  final DynamicLinksService _dynamicLinksService = locator<DynamicLinksService>();
  final AuthService _authServices = locator<AuthService>();
  logOut(){
    _authServices.logOut();
    _navigationService.clearStackAndShow(authOptions);
  }
  List<Post> _userPosts;
  List<Post> get userPosts=>_userPosts;

  AppUser get currentUser=>_authServices.currentUser;
  bool isCurrentUser=false;
  bool isFollowing=false;

  AppUser _profileUser;
  AppUser get profileUser=>_profileUser;

  void listenToUserProfileData(String userId)async{

    setBusy(true);
    var _user=await _firestoreService.getUser(userId);
    if(_user is AppUser){
      _profileUser=_user;
      isCurrentUser=_profileUser.id==currentUser.id;
      isFollowing=_profileUser.followers.contains(currentUser.id);
    }
    else if(_user == String ){
      setBusy(false);
      _snackBarService.showSnackbar(message: _user);
      await Future.delayed(Duration(seconds: 2));
      _navigationService.back();
      _navigationService.back();
      return;
    }else{
      setBusy(false);
      _snackBarService.showSnackbar(message: "User doesn't exist");
      await Future.delayed(Duration(seconds: 2));
      _navigationService.back();
      _navigationService.back();
      return;
    }
    setBusy(false);
    _firestoreService.listenToSearchedUserPosts(userId: userId).listen((posts) {
      List<Post> updatedPosts=posts;
      if(updatedPosts!=null){
        print(updatedPosts);
        _userPosts=updatedPosts;
        notifyListeners();
      }

    });
  }
  popView(){
    _navigationService.back();
  }
  shareProfile()async{

      String postUrl=await _dynamicLinksService.createUserLink(profileUser.id);
      Share.share('$postUrl');
  }
  void requestMoreUserData() => _firestoreService.requestMoreCurrentUserData(userId: _profileUser.id);

  goToPostPreview({@required Post post}){
    _navigationService.navigateToView(PostView(post: post,));
  }

  deletePost(String id){
    _firestoreService.deletePost(postId:id);
//      #Todo delete images from backend
  }
}