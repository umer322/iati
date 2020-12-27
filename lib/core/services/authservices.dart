
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iati/models/user.dart';
import '../../locator.dart';
import 'api.dart';

class AuthService{
  final Api _api=locator<Api>();
  AppUser get currentUser=>_api.currentUser;
  Future<bool> isUserLoggedIn()=> _api.isUserLoggedIn();
  Future loginWithEmail({@required String email,@required String password})=>_api.loginWithEmail(email: email, password: password);
  Future signUpWithEmailAndPassword({@required String email,@required String password,@required AppUser user}) => _api.signUpWithEmail(email: email, password: password,user: user);
  Future logOut()=>_api.logOut();
  Future checkEmailAvailibility({@required email})=>_api.checkEmailAvailability(email: email);
  Future updateUser({@required AppUser user})=>_api.updateUser(user);
  Future loginWithGoogle()=>_api.loginWithGoogle();
  Future loginWithFacebook()=>_api.loginWithFacebook();
  Future userAlreadyExist({@required String uid})=>_api.userAlreadyExist(uid: uid);
  Future createNewUser({@required User user,@required String uid})=>_api.createNewUser(user: user, uid: uid);
  Future populateCurrentUser()=>_api.populateCurrentUser();
}
