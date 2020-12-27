
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/user.dart';

class Api{
  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirestoreService _fireStoreService = locator<FirestoreService>();
  AppUser _currentUser;
  AppUser get currentUser =>_currentUser;

  Future<bool> isUserLoggedIn()async{
   var user=_auth.currentUser;
   await _populateCurrentUser(user,true);
   return user!=null;
  }

  Future loginWithEmail({@required String email,@required password})async{
    try{
      var authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _populateCurrentUser(authResult.user,true);
      return authResult.user!=null;
    }
    catch(e){
      List<String> list=await _auth.fetchSignInMethodsForEmail(email);
      if(list.length>0) {
        if (list.contains("google.com")) {
          return "You previously signed up with Google";
        }
        else if (list.contains("facebook.com")) {
          return "You previously signed up with Facebook";
        }
      }
      return e.message;
    }
  }

  Future signUpWithEmail({@required String email,@required String password,@required AppUser user})async{
    try{
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(authResult.user!=null){
        await _fireStoreService.createNewUser(user: user, id: authResult.user.uid);
        await populateCurrentUser();
      }
      return authResult.user!=null;
    }catch(e){
      return e.message;
    }
  }

  Future logOut()async{
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    await _auth.signOut();
    await populateCurrentUser();
  }

  Future<bool> checkEmailAvailability({@required String email})async{
    try{
      List<String> data=await _auth.fetchSignInMethodsForEmail(email);
      if(data.length>0){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return e.message;
    }
  }
  populateCurrentUser()=>_populateCurrentUser(_auth.currentUser, true);
  Future _populateCurrentUser(User user,bool must)async{
    if(user!=null){
      if(_currentUser==null){
        _currentUser = await _fireStoreService.getUser(user.uid);
      }
      else{
        if(must){
          _currentUser = await _fireStoreService.getUser(user.uid);
        }else{
          print("not gonna update");
        }
      }
    }
    else{
      _currentUser=null;
    }
  }

  Future updateUser(AppUser user)async{
    await _fireStoreService.updateUser(user: user);
    await _populateCurrentUser(_auth.currentUser,true);
  }

  Future<bool> userAlreadyExist({@required String uid})async{
    bool result= await _fireStoreService.userExists(uid);
    return result;
  }

  createNewUser({@required User user,@required String uid})async{
    await _fireStoreService.createNewUser(user: AppUser(id: user.uid,email: user.email,imageUrl: user.photoURL,name: user.displayName), id: user.uid);
    await _populateCurrentUser(_auth.currentUser,true);
  }

  Future loginWithFacebook()async{
    try{
      final result = await facebookLogin.logIn(['email']);
      switch (result.status){
        case FacebookLoginStatus.loggedIn:
          print("user logged in");
          final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
          final UserCredential authResult = await _auth.signInWithCredential(credential);
          User user = authResult.user;
          print("returnign from google");
          if(user!=null) {
            return user;
          }
          else{
            return false;
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          return "Login cancelled by user";
        case FacebookLoginStatus.error:
          return "Error occured while signing in by facebook";
        default:
          return "Error occured";
      }
    }
    catch(e){
      print("error 2 ${e}");
      return e.message;
    }
  }

  Future loginWithGoogle()async{
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      if(googleSignInAccount==null){
        return "Cancelled by User";
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      User user = authResult.user;
      print("returnign from google");
      if(user!=null) {
        return user;
      }
      else{
        return false;
      }
    } catch (error) {
      return error.message;

    }
  }
}