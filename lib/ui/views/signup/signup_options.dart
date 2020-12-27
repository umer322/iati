import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:stacked/stacked.dart';

class SignUpOptionsView extends StatelessWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>SignUpOptionsView());
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        disposeViewModel: false,
        builder: (context,model,child){
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true,title: Text("Sign Up",)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07,vertical: MediaQuery.of(context).size.height*0.04),
          child: model.isBusy?Center(child: AppProgressIndication()):Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText("Sign Up for I AM THE INDUSTRY",presetFontSizes: [22,21,20,19,18,16],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),maxLines: 1,),
              SizedBox(height: 5,),
              AutoSizeText("Create a profile,upload your own content,get paid and more",style: TextStyle(color: Colors.black54),),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              GestureDetector(
                onTap: (){
                 model.goToSignUpEmailPage();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12,width: 1)
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.person_outline),
                    ),
                    Expanded(
                        flex: 2,
                        child: SizedBox()),
                    AutoSizeText("Use Email"),
                    Expanded(
                        flex: 3,
                        child: SizedBox())
                  ],),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              GestureDetector(

                child: Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12,width: 1)
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset("assets/facebook.png"),
                    ),
                    Expanded(
                        flex: 2,
                        child: SizedBox()),
                    AutoSizeText("Continue with Facebook"),
                    Expanded(
                        flex: 3,
                        child: SizedBox())
                  ],),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              GestureDetector(
                onTap: (){
                  model.loginWithGoogle();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12,width: 1)
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset("assets/google.png",),
                    ),
                    Expanded(
                        flex: 2,
                        child: SizedBox()),
                    AutoSizeText("Continue with Google"),
                    Expanded(
                        flex: 3,
                        child: SizedBox())
                  ],),
                ),
              ),
              Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText("By signing up,you agree to our",style: TextStyle(color: secondaryColor),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                  SizedBox(height: 5,),
                  AutoSizeText.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(color: primaryColor),
                        ),
                        TextSpan(
                            text: " & "
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(color: primaryColor),
                        ),
                      ]
                  ),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  AutoSizeText.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                        ),
                        TextSpan(
                            text: "Log in here",
                            style: TextStyle(color: primaryColor),
                            recognizer: TapGestureRecognizer()..onTap=(){
                                model.switchToLogin();
                            }
                        ),
                      ]
                  ),textAlign: TextAlign.center,presetFontSizes: [16,14],),
                ],)
            ],
          ),
        ),
      );
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}
