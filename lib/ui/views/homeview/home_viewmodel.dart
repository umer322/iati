import 'package:iati/locator.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends IndexTrackingViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  goToPostCreationPage()async{
   _navigationService.navigateTo(postCreationInitView);
  }
}