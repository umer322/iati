import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestorage_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostEditViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackBarService = locator<SnackbarService>();
  final FirestoreService _firestoreService=locator<FirestoreService>();
  final FireStorageService _fireStorageService=locator<FireStorageService>();

  final AuthService _authServices = locator<AuthService>();
  AppUser get currentUser=>_authServices.currentUser;
  Post _post;
  Post get currentPost=>_post;

  setPost(Post post){
    _post=post;
  }

  editPostAndGoBack(){
      _firestoreService.editPost(currentPost);
     _navigationService.back();
  }
}