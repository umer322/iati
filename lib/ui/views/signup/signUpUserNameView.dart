

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpUserName extends HookViewModelWidget<SignUpViewModel> {

  @override
  Widget buildViewModelWidget(BuildContext context, SignUpViewModel viewModel) {
    var usernameController=useTextEditingController();
   return Scaffold(
     appBar: AppBar(automaticallyImplyLeading: true,title: Text("Sign Up",)),
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07,vertical: MediaQuery.of(context).size.height*0.04),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           AutoSizeText("Create username",presetFontSizes: [22,21,20,19,18,16],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),maxLines: 1,),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           AutoSizeText("You can always change this later.",style: TextStyle(color: Colors.black38,height: 1.5),presetFontSizes: [16,14,12],maxLines: 2,),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           TextField(
             maxLength: 30,
             controller: usernameController,
             onChanged: viewModel.onUserNameChanged,
             decoration: InputDecoration(
               hintText: "Username",
               hintStyle: TextStyle(color: Colors.black26),
             ),
           ),
           AutoSizeText(viewModel.userNameTExtFieldError,style: TextStyle(color: Colors.red),),
           SizedBox(height: MediaQuery.of(context).size.height*0.02,),
           GestureDetector(
             onTap: ()async{
                viewModel.goToBirthDayView(usernameController.text);
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
