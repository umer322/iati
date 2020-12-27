
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/realtimedatabase_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/comment_model.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CommentsViewModel extends BaseViewModel{

  final AuthService _authService=locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final RealTimeDataBase _realTimeDataBase=locator<RealTimeDataBase>();

  List<CommentModel> _comments;
  List<CommentModel> get comments=>_comments;

  AppUser get currentUser=>_authService.currentUser;
  Post _currentPost;
  Post get currentPost=>_currentPost;
  AppUser _postUser;
  AppUser get postUser=>_postUser;


  bool longCaption=false;
  bool hasLongCaption=false;
  bool writingComment=false;


  changeCommentState(String val){
    if(val.length>0){
      writingComment=true;
      notifyListeners();
    }else{
      writingComment=false;
      notifyListeners();
    }
  }

  toggleCaption(){
    longCaption=!longCaption;
    notifyListeners();
  }

  listenToComments(Post post,AppUser user){
    setBusy(true);
      _currentPost=post;
      _postUser=user;
      hasLongCaption=currentPost.caption.length>90;
      longCaption=currentPost.caption.length>90;
    _realTimeDataBase.listenToPostComments(postId: _currentPost.id).listen((updatedPostComments) {
      if(updatedPostComments!=null){
        _comments=updatedPostComments;
        setBusy(false);
        notifyListeners();
      }else{
        setBusy(false);
      }
    });
  }

  goToUserProfile(String userId){
    _navigationService.navigateTo(userProfileView,arguments: userId);
  }

  back(){
    _navigationService.back();
  }
  addComment(String comment){
    print(comment);
    CommentModel userComment=CommentModel(
      userId: currentUser.id,
      comment: comment,
      time: DateTime.now(),
      replies: [],
      likes: []
    );
    _realTimeDataBase.writeComment(userComment,_currentPost.id);
  }
}