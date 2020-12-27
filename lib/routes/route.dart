import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/auth_options/auth_view.dart';
import 'package:iati/ui/views/homeview/home_view.dart';
import 'package:iati/ui/views/homeview/userprofile/alluserpropfile_view.dart';
import 'package:iati/ui/views/post_views/comments_view/comments_view.dart';
import 'package:iati/ui/views/postcreation/album_select_view.dart';
import 'package:iati/ui/views/postcreation/postcreation_view.dart';
import 'package:iati/ui/views/postcreation/postcreationdetail_view.dart';
import 'package:iati/ui/views/signup/login_view.dart';
import 'package:iati/ui/views/signup/signUpBirthDayView.dart';
import 'package:iati/ui/views/signup/signUpFavoriteCategories.dart';
import 'package:iati/ui/views/signup/signup_options.dart';
import 'package:iati/ui/views/signup/signupemailpage_view.dart';
import 'package:iati/ui/views/signup/signuptemplate_view.dart';
import 'package:iati/ui/views/signup/userSuggestionView.dart';
import 'package:iati/ui/views/splashscreen/splashscreen_view.dart';

class AppRoute{
  static Route generateRoute(RouteSettings settings){
    switch(settings.name){
      case Navigator.defaultRouteName:
        return SplashScreen.route();
      case authOptions:
        return AuthOptions.route();
      case loginView:
        return LoginView.route();
      case signUpOptions:
        return SignUpOptionsView.route();
      case signUpEmailPage:
          return SignUpEmailPage.route();
      case signUpTemplateView:
        var child=settings.arguments;
        return SignUpTemplateView.route(child);
      case signUpBirthDay:
        return SignUpBirthDayView.route();
      case favoriteCategories:
        return FavoriteCategories.route();
      case userSuggestions:
        return UserSuggestionView.route();
      case homeView:
        return HomeView.route();
      case postCreationInitView:
        return PostCreationView.route();
      case postCreationDetailView:
        return DetailPostCreationView.route();
      case userProfileView:
        String userId=settings.arguments;
        return UserProfileView.route(userId);
      case commentsView:
        List data=settings.arguments;
        return CommentsView.route(data[0],data[1]);
      case selectAlbumView:
        return AlbumSelectView.route();
      default:
        return MaterialPageRoute(builder: (_)=>Scaffold(
          body: Center(child: Text("No route link specified for this route"),),
        ));
    }
  }
}