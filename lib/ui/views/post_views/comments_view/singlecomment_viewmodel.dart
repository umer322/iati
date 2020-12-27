
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/core/services/realtimedatabase_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/comment_model.dart';
import 'package:iati/models/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleCommentViewModel extends BaseViewModel{
  final AuthService _authService=locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final RealTimeDataBase _realTimeDataBase=locator<RealTimeDataBase>();
  final FirestoreService _firestoreService =locator<FirestoreService>();

  AppUser get currentUser=>_authService.currentUser;
  bool fetchedComment=true;

  AppUser _commentUser;
  AppUser get commentUser=>_commentUser;

  CommentModel _currentComment;
  CommentModel get currentComment=>_currentComment;

  initialise(CommentModel comment)async{
    _currentComment=comment;
    var user=await _firestoreService.getUser(comment.userId);
    if(user is AppUser){
      _commentUser=user;
      notifyListeners();
    }else{
      fetchedComment=false;
      notifyListeners();
    }

  }
}