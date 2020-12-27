import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TimeLineViewModel extends BaseViewModel{

  final FirestoreService _fireStoreServices=locator<FirestoreService>();
  final AuthService _authService=locator<AuthService>();
  AppUser get currentUser=>_authService.currentUser;

  List<AppUser> _suggestedUsers;
  List<AppUser> get suggestedUsers=>_suggestedUsers;

  listenToTimeLinePosts()async{
      if(currentUser.following.length==0){
        setBusy(true);
        _fireStoreServices.listenToSuggestedUsers(userId: currentUser.id).listen((newSuggestedUsers) {
          if(newSuggestedUsers!=null){
            _suggestedUsers=newSuggestedUsers;
            setBusy(false);
            notifyListeners();
          }else{
            setBusy(false);
          }
        });
      }
  }

  requestMoreData()=>_fireStoreServices.requestMoreSuggestedUserData(userId: currentUser.id);

  followUser(String userId)async{
   await _fireStoreServices.followUser(userId, currentUser.id);
  }
  refreshView()async{
    await _authService.populateCurrentUser();
    notifyListeners();
  }
}