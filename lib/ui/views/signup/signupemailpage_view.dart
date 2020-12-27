
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SignUpEmailPage extends HookViewModelWidget<SignUpViewModel> {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>SignUpEmailPage());
  }
  @override
  Widget buildViewModelWidget(BuildContext context, SignUpViewModel viewModel) {
    final emailController=useTextEditingController();
   return Scaffold(
     appBar: AppBar(automaticallyImplyLeading: true,title: Text("Sign Up",)),
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07,vertical: MediaQuery.of(context).size.height*0.04),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           TextField(
             controller: emailController,
              onChanged: viewModel.onEmailValueChanged,
              decoration: InputDecoration(
                hintText: "Email Address",
                hintStyle: TextStyle(color: Colors.black26),
              ),
           ),
           AutoSizeText(viewModel.emailTextFieldError,style: TextStyle(color: Colors.red),),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           SizedBox(height: 5,),
           AutoSizeText.rich(TextSpan(children: [
             TextSpan(text: "By continuing, you agree to our "),
             TextSpan(text: "Terms of Use",style: TextStyle(color: primaryColor)),
             TextSpan(text: " and confirm that you have read our "),
             TextSpan(text: "Privacy Policy",style: TextStyle(color: primaryColor))
           ]),style: TextStyle(color: Colors.black38,height: 1.5),presetFontSizes: [16,14,12],maxLines: 2,),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           viewModel.isBusy?Center(child: AppProgressIndication(),):GestureDetector(
              onTap: (){
                viewModel.checkEmailAvailibility(email: emailController.text);
              },
             child: Container(
               height: MediaQuery.of(context).size.height*0.05,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(50),
                   color: primaryColor
               ),
               child: Center(child: AutoSizeText("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),presetFontSizes: [18,16,14],),),
             ),
           ),
           Expanded(child: SizedBox()),
         ],
       ),
     ),
   );
  }
}
