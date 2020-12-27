

import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>LoginView());
  }
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _email;
  String _password;
  bool _loading=false;
  final _formKey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool showPassword=true;


  @override
  void dispose() {
    // TODO: implement dispose
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        disposeViewModel: false,
        builder: (context,model,child){
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar:AppBar(automaticallyImplyLeading: true,title: Text("Login",)),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.1),
          child: Form(
            key: _formKey,
            child: model.isBusy?Center(child: AppProgressIndication()):Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SizedBox()),
                Center(child: Image.asset("assets/logo.png",width: MediaQuery.of(context).size.width/2.5,)),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                TextFormField(
                  controller: emailController,
                  validator: (val){
                    if(val.isEmpty){
                      return "Email is required";
                    }
                    if(!EmailValidator.validate(val)){
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (val){
                    _email=val;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 2)
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                TextFormField(
                  controller: passwordController,
                  validator: (val){
                    if(val.isEmpty){
                      return "Password is required";
                    }
                    if(val.length<8){
                      return "Password should be atleast 8 characters long";
                    }
                    return null;
                  },
                  obscureText: showPassword,
                  onSaved: (val){
                    _password=val;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(icon: showPassword?Icon(Icons.visibility):Icon(Icons.visibility_off), onPressed:(){
                      setState(() {
                        showPassword=!showPassword;
                      });
                    },color: Colors.black26,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: AutoSizeText("Forgot Password?",style: TextStyle(color: Colors.grey),),
                  ),],),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Center(
                  child:GestureDetector(
                    onTap: _loading?null:()async{
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                         model.logInUser(email: _email, password: _password);

                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color:lightPrimaryColor
                      ),
                      height: MediaQuery.of(context).size.height*0.045,
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Center(child: AutoSizeText("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14],),),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                AutoSizeText("Or log in with:",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,letterSpacing: 1.3),presetFontSizes: [18,16,14],),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        model.loginWithGoogle();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: MediaQuery.of(context).size.height*0.045,
                        decoration: BoxDecoration(
                            color: Color(0xffF3553C),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(

                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/google_plus.png"),
                            ),
                            Expanded(flex:1,child: SizedBox()),
                            AutoSizeText("Google+",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),presetFontSizes: [16,14],),
                            Expanded(
                                flex: 2,
                                child: SizedBox())
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        model.loginWithFacebook();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: MediaQuery.of(context).size.height*0.045,
                        decoration: BoxDecoration(
                            color: Color(0xff3B5999),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/facebook_white.png"),
                            ),
                            Expanded(flex:1,child: SizedBox()),
                            AutoSizeText("Facebook",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),presetFontSizes: [16,14],),
                            Expanded(
                                flex: 2,
                                child: SizedBox())
                          ],
                        ),
                      ),
                    )
                  ],),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AutoSizeText("By signing in,you agree to our",style: TextStyle(color:secondaryColor),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                    SizedBox(height: 5,),
                    AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(color:primaryColor),
                          ),
                          TextSpan(
                              text: " & "
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(color:primaryColor),
                          ),
                        ]
                    ),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                    AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an Account? ",
                          ),
                          TextSpan(
                              text: "Sign up here",
                              style: TextStyle(color:primaryColor),
                              recognizer: TapGestureRecognizer()..onTap=(){
                                  model.switchToSignUp();
                              }
                          ),
                        ]
                    ),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                  ],),
                Expanded(child: SizedBox())
              ],),
          ),
        ),
      );
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}

