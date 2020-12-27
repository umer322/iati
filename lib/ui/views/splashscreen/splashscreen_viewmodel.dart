
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/dynamiclinks_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../locator.dart';

class SplashViewModel extends BaseViewModel{
  final AuthService _authService=locator<AuthService>();
  final NavigationService _navigationService=locator<NavigationService>();
  final DynamicLinksService _dynamicLinksService=locator<DynamicLinksService>();
  final DialogService _dialogService =locator<DialogService>();
  Future handleStartupLogic()async{
//   await _authService.logOut();
    await Future.delayed(Duration(seconds: 1));
    var response=await _authService.isUserLoggedIn();
    if(response){
      await _authService.populateCurrentUser();
      await _dynamicLinksService.handleDynamicLinks();
      _navigationService.replaceWith(homeView);
    }else{
      _navigationService.replaceWith(authOptions);
    }
  }

  goToUserProfile(String id){
    _navigationService.navigateTo(userProfileView,arguments: id);
  }

}