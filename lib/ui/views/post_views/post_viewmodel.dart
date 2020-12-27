
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/ui/views/post_views/postedit_view/postedit_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

class PostViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  final FirestoreService _firestoreService=locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthService _authServices = locator<AuthService>();

  AppUser get currentUser=>_authServices.currentUser;
  Post _currentPost;
  Post get currentPost=>_currentPost;
  AppUser _postUser;
  AppUser get postUser=>_postUser;
  bool longCaption=false;
  bool hasLongCaption;
  listenToData({@required String postId,@required String userID})async{
    setBusy(true);
    var user=await _firestoreService.getUser(userID);
    if(user is AppUser){
      _postUser=user;
    }else{
      _snackBarService.showSnackbar(message: "Cannot fetch current post data");
      await Future.delayed(Duration(seconds: 1));
      _navigationService.back();
      setBusy(false);
      return;
    }
    await updatePost(postId);
    hasLongCaption=currentPost.caption.length>90;
    longCaption=currentPost.caption.length>90;
    setBusy(false);

  }
  updatePost(String postId)async{
    var post=await _firestoreService.getSinglePost(postId);
    if(post is Post){
      _currentPost=post;
    }
    else{
      _snackBarService.showSnackbar(message: "Cannot fetch current post data");
      await Future.delayed(Duration(seconds: 1));
      setBusy(false);
      return;
    }
  }
  popView(){
    _navigationService.back();
  }
  deletePost(){
      _firestoreService.deletePost(postId: currentPost.id);
//      #Todo delete images from backend
  }

  editPost()async{
      await _navigationService.navigateToView(PostEditView(_currentPost));
      await updatePost(_currentPost.id);
      notifyListeners();
  }

  toggleCaption(bool view){
    longCaption=view;
    notifyListeners();
  }

}