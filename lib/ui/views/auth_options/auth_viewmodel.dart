import 'package:iati/routes/routes_const.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../locator.dart';

class AuthOptionsViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  void goToLogin()async{
//    await Future.delayed(Duration(milliseconds: 300));
    _navigationService.navigateTo(loginView);
  }
  void goToSignUp()async{
//    await Future.delayed(Duration(milliseconds: 300));
    _navigationService.navigateTo(signUpOptions);
  }
}