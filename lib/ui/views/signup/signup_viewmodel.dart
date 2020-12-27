import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/signup/signUpPasswordView.dart';
import 'package:iati/ui/views/signup/signUpUserNameView.dart';
import 'package:iati/ui/views/signup/signupemailpage_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class SignUpViewModel extends BaseViewModel{
  final AuthService _authService=locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  AppUser _user=AppUser();
  bool obscureText=true;
  String emailTextFieldError="";
  String passwordTextFieldError="";
  String userNameTExtFieldError="";


  void checkEmailAvailibility({@required String email})async{
    bool validEmail=checkValidEmail(email);
    if(validEmail){
      return;
    }
    setBusy(true);
    var response = await _authService.checkEmailAvailibility(email: email);
    setBusy(false);
    if(response is bool){
      if(response){
        _dialogService.showDialog(
          title: "Sign Up Failed",
          description: "Email already used by another account",
        );
      }
      else{
        _user.email=email;
        emailTextFieldError="";
        _navigationService.navigateTo(signUpTemplateView,arguments: SignUpPasswordView());
      }
    }else{
      _dialogService.showDialog(
        title: "Sign Up Failed",
        description: response,
      );
    }
  }


  logInUser({@required String email,@required String password})async{
    var response=await runBusyFuture(_authService.loginWithEmail(email: email, password: password));
    if(response is bool){
      if(response){
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
      }
      else{
        _dialogService.showDialog(
          title: "Login Failed",
          description: "General login failure.Please try again later",
        );
      }
    }else{
      _dialogService.showDialog(
        title: "Login Failed",
        description: response??"",
      );
    }
  }

  loginWithGoogle()async{
    var response=await runBusyFuture(_authService.loginWithGoogle());
    if(response is User){
      print(response.uid);
      bool userExist=await runBusyFuture(_authService.userAlreadyExist(uid: response.uid));
      if(userExist){
        await _authService.populateCurrentUser();
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
      }
      else{
        _user.id=response.uid;
        _user.email=response.email;
        _user.imageUrl=response.photoURL;
        _user.name=response.displayName;
        await _authService.createNewUser(user: response, uid: response.uid);
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
        _navigationService.navigateTo(signUpTemplateView,arguments: SignUpUserName());
      }
    }
    else if(response is bool){
      if(response){
        await _authService.populateCurrentUser();
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
      }
      else{
        _dialogService.showDialog(
          title: "Login Failed",
          description: "General login failure.Please try again later",
        );
      }
    }else{
      _dialogService.showDialog(
        title: "Login Failed",
        description: response??"",
      );
    }
  }

  loginWithFacebook()async{
    var response=await runBusyFuture(_authService.loginWithFacebook());
    if(response is User){
      print(response.uid);
      bool userExist=await runBusyFuture(_authService.userAlreadyExist(uid: response.uid));
      if(userExist){
        await _authService.populateCurrentUser();
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
      }
      else{
        _user.id=response.uid;
        _user.email=response.email;
        _user.imageUrl=response.photoURL;
        _user.name=response.displayName;
        await _authService.createNewUser(user: response, uid: response.uid);
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
        _navigationService.navigateTo(signUpTemplateView,arguments: SignUpUserName());
      }
    }
    else if(response is bool){
      if(response){
        await _authService.populateCurrentUser();
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
      }
      else{
        _dialogService.showDialog(
          title: "Login Failed",
          description: "General login failure.Please try again later",
        );
      }
    }else{
      _dialogService.showDialog(
        title: "Login Failed",
        description: response??"",
      );
    }
  }
  signUpUser({@required String password})async{
    bool validPassword=checkPassword(password);
    if(validPassword){
      return;
    }
    var response=await runBusyFuture(_authService.signUpWithEmailAndPassword(email: _user.email, password: password,user: _user));
    if(response is bool){
      if(response){
        passwordTextFieldError="";
        _navigationService.popUntil((route) => route.isFirst);
        _navigationService.replaceWith(homeView);
        _navigationService.navigateTo(signUpTemplateView,arguments: SignUpUserName());
      }
      else{
        _dialogService.showDialog(
          title: "Sign Up Failed",
          description: "General sign up failure.Please try again later",
        );
      }
    }else{
      _dialogService.showDialog(
        title: "Sign Up Failed",
        description: response,
      );
    }
  }

  goToBirthDayView(String name){
    bool checkUser=checkUserName(name);
    if(checkUser){
      return;
    }
    userNameTExtFieldError="";
    _user.userName=name;
    _navigationService.navigateTo(signUpBirthDay);
  }

  goToFavoritesCategory(date){
    _user.birthDay=date;
    _navigationService.navigateTo(favoriteCategories);
  }
  goToUserSuggestions(List<String> favorites){
    _user.favoriteCategories=favorites;
    _navigationService.navigateTo(userSuggestions);
  }

  updateUserAndGoHomePage()async{
      await runBusyFuture(_authService.updateUser(user: _user));
      _navigationService.popUntil((route) => route.isFirst);
      _navigationService.navigateTo(homeView);
  }
  checkUserName(String val){
    final validCharacters = RegExp(r'^[a-zA-Z0-9_.]+$');
    if(val.isEmpty){
      userNameTExtFieldError="Username is required";
      notifyListeners();
      return true;
    }else if(val.length<6){
      userNameTExtFieldError="Username should be atleast 6 characters long";
      notifyListeners();
      return true;
    }
    else if(!validCharacters.hasMatch(val)){
      userNameTExtFieldError="Username should not contain any special characters";
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }
  checkValidEmail(String val){
    if(val.isEmpty){
      emailTextFieldError="Email is required";
      notifyListeners();
      return true;
    }
    if(!EmailValidator.validate(val)){
      emailTextFieldError="Please Enter Valid Email";
      notifyListeners();
      return true;
    }else{
      return false;
    }
  }

  checkPassword(String val){
    if(val.isEmpty){
      passwordTextFieldError="Password is required";
      notifyListeners();
      return true;
    }else if(val.length<8){
      passwordTextFieldError="Password should be atleast 8 characters long";
      notifyListeners();
      return true;
    }
    else if(!val.contains(new RegExp(r'[A-Za-z]'))){
      passwordTextFieldError="Password should have atleast one alphabet";
      notifyListeners();
      return true;
    }
    else if(!val.contains(new RegExp(r'[0-9]'))){
      passwordTextFieldError="Password should have atleast one number";
      notifyListeners();
      return true;
    }
    else if(!val.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      passwordTextFieldError="Password doesn't contain any special characters";
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }
  changeObscureText(){
    obscureText=!obscureText;
    notifyListeners();
  }
  onEmailValueChanged(String val){
    emailTextFieldError="";
    notifyListeners();
  }
  onUserNameChanged(String val){
    userNameTExtFieldError="";
    notifyListeners();
  }
  onPasswordValueChanged(String val){
    passwordTextFieldError="";
    notifyListeners();
  }

  switchToLogin(){
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(loginView);
  }
  switchToSignUp(){
    _navigationService.popRepeated(1);
    _navigationService.navigateTo(signUpOptions);
  }
  void goToSignUpEmailPage()async{
//    await Future.delayed(Duration(milliseconds: 300));
    _navigationService.navigateTo(signUpTemplateView,arguments: SignUpEmailPage());
  }

}