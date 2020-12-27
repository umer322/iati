import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/auth_options/auth_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AuthOptions extends StatelessWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>AuthOptions(),settings: RouteSettings(name: "AuthOptions"));
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthOptionsViewModel>.nonReactive(builder: (context,model,child){
      return Material(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: SizedBox()),
            Hero(
                tag: "logo",
                child: Image.asset("assets/logo.png")),
            SizedBox(height: MediaQuery.of(context).size.height*0.04,),
            Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
              child: Column(children: [
                Image.asset("assets/name.png"),
                SizedBox(height:getHeigth(context, 0.02),),
                AutoSizeText("ALL THE CONTENT YOU LOVE. YOUR WAY.",presetFontSizes: [26,24,22,20,18,17,16,15,14,13,12,11,10],style: TextStyle(color: secondaryColor,letterSpacing: 1.2),maxLines: 1,textAlign: TextAlign.center,)
              ],),),
            Expanded(
                flex: 1,
                child: SizedBox()),
            Padding(padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      model.goToSignUp();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black45,width: 1)
                      ),
                      child: Center(child: AutoSizeText("SIGN UP",style: TextStyle(color: secondaryColor,fontWeight: FontWeight.w500),presetFontSizes: [18,16,14],),),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  GestureDetector(
                    onTap: (){
                        model.goToLogin();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: primaryColor
                      ),
                      child: Center(child: AutoSizeText("LOGIN",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),presetFontSizes: [18,16,14],),),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                  AutoSizeText("By continuing you agree to our",style: TextStyle(color: secondaryColor),presetFontSizes: [16,14],),
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
                          text: "Privacy Policy.",
                          style: TextStyle(color: primaryColor),
                        ),
                      ]
                  ),presetFontSizes: [16,14],)
                ],
              ),),
            Expanded(child: SizedBox()),
          ],
        ),
      );
    }, viewModelBuilder: ()=>AuthOptionsViewModel());
  }
}