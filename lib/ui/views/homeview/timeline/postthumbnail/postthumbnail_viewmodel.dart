import 'package:chewie/chewie.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/dynamiclinks_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/post_views/comments_view/comments_view.dart';
import 'package:iati/ui/views/post_views/postedit_view/postedit_view.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

class PostThumbnailViewModel extends BaseViewModel{
        final FirestoreService _firestoreService=locator<FirestoreService>();
        final AuthService _authService=locator<AuthService>();
        final NavigationService _navigationService = locator<NavigationService>();
        final DynamicLinksService _dynamicLinksService=locator<DynamicLinksService>();
        final SnackbarService _snackbarService = locator<SnackbarService>();
        VideoPlayerController videoPlayerController;
        ChewieController chewieController;


        AppUser get currentUser=>_authService.currentUser;
        bool isLiked=false;
        AppUser _postUser;
        AppUser get postUser=>_postUser;
        bool userOwnPost=false;
        Post _currentPost;
        Post get currentPost=>_currentPost;
        bool longCaption=false;
        bool hasLongCaption=false;


        listenToData({@required Post post,@required String userID})async{
          setPostData(post);
          userOwnPost=currentUser.id==post.userId;
          isLiked=post.likes.contains(currentUser.id);
          setBusy(true);
          var user=await _firestoreService.getUser(userID);
          if(user is AppUser){
            _postUser=user;
          }else{
            setBusy(false);
            return;
          }
          setBusy(false);
          if(currentPost!=null && currentPost.fileUrls[0].isVideo){
            if(_currentPost.fileUrls[0].isVideo){
              videoPlayerController = VideoPlayerController.network(_currentPost.fileUrls[0].file);
              await videoPlayerController.initialize();
              chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                showControlsOnInitialize: false
              );

            }
          }
          notifyListeners();
        }

        setPostData(Post post){
          _currentPost=post;
          hasLongCaption=currentPost.caption.length>90;
          longCaption=currentPost.caption.length>90;
          notifyListeners();
        }
        toggleCaption(bool view){
          longCaption=view;
          notifyListeners();
        }

        likePost()async{
          print("liking post");
            await _firestoreService.likePost(postId: currentPost.id, userId: currentUser.id);
            isLiked=true;
            _currentPost.likes.add(currentUser.id);
            notifyListeners();
        }

        unLikePost()async{
          print("unliking post");
          _firestoreService.unLikePost(postId: currentPost.id, userId: currentUser.id);
          isLiked=false;
          _currentPost.likes.remove(currentUser.id);
          notifyListeners();
        }

        editPost()async{
          await _navigationService.navigateToView(PostEditView(_currentPost));
          notifyListeners();
        }

        popView(){
          _navigationService.back();
        }
        deletePost(){
          _firestoreService.deletePost(postId: currentPost.id);
//      #Todo delete images from backend
        }

        sharePost()async{
          if(currentPost.postLink==null)
            {
              String postUrl=await _dynamicLinksService.createPostLink(currentPost.id);
              Uri link=Uri.parse(postUrl);
              Share.share('$postUrl');
            }
          else{
            Share.share('${currentPost.postLink}');
          }
        }

        copyPostLink()async{
          if(currentPost.postLink==null)
          {
            String postUrl=await _dynamicLinksService.createPostLink(currentPost.id);
            Clipboard.setData(ClipboardData(text: postUrl));
            _snackbarService.showSnackbar(message: "link copied");
          }
          else{
            Clipboard.setData(ClipboardData(text: currentPost.postLink));
            _snackbarService.showSnackbar(message: "link copied");
          }
        }
        goToUserProfile(){
          _navigationService.navigateTo(userProfileView,arguments: postUser.id);
        }

        goToCommentsView(){
          _navigationService.navigateTo(commentsView,arguments: [_currentPost,_postUser]);
        }
}