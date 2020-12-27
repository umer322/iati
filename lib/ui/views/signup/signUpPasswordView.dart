import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpPasswordView extends HookViewModelWidget<SignUpViewModel> {

  @override
  Widget buildViewModelWidget(BuildContext context, SignUpViewModel viewModel) {
    var passwordController=useTextEditingController();
   return Scaffold(
     appBar: AppBar(automaticallyImplyLeading: true,title: Text("Sign Up",)),
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07,vertical: MediaQuery.of(context).size.height*0.04),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           AutoSizeText("Create Password",presetFontSizes: [22,21,20,19,18,16],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),maxLines: 1,),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           AutoSizeText("Use 8-20 characters and atleast one symbol or number",style: TextStyle(color: Colors.black38,height: 1.5),presetFontSizes: [16,14,12],maxLines: 2,),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           TextField(
             controller: passwordController,
             onChanged: viewModel.onPasswordValueChanged,
             obscureText: viewModel.obscureText,
             decoration: InputDecoration(
               hintText: "Password",
               hintStyle: TextStyle(color: Colors.black26),
               suffixIcon: IconButton(icon: viewModel.obscureText?Icon(Icons.visibility):Icon(Icons.visibility_off), onPressed:(){
                viewModel.changeObscureText();
               },color: Colors.black26,),
             ),
           ),
           AutoSizeText(viewModel.passwordTextFieldError,style: TextStyle(color: Colors.red),),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           viewModel.isBusy?Center(child: AppProgressIndication(),):GestureDetector(
             onTap: ()async{
                viewModel.signUpUser(password: passwordController.text);
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
