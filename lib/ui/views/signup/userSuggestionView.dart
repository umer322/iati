import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/user.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class UserSuggestionView extends StatelessWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>UserSuggestionView());
  }
  final List<AppUser> users = [];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.nonReactive(builder: (context,model,child){
      return Scaffold(
          appBar: AppBar(title: Image.asset("assets/logo.png",width: 80,),
            centerTitle: true,
            leading: InkWell(
                onTap: (){
                  model.updateUserAndGoHomePage();
                },
                child: Center(child: AutoSizeText("Skip",maxLines: 1,))),
            actions: [FlatButton(onPressed: ()async{
              model.updateUserAndGoHomePage();
            }, child: Text("Done"))],),
          body: Padding(
            padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
            child: ListView.separated(itemBuilder: (BuildContext context,int index){
              return index==0?
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
                child: Column(children: [
                  AutoSizeText("Personalize your feed",presetFontSizes: [22,21,20,19,18,16],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),maxLines: 1,),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                  AutoSizeText("Follow people from the suggestions below\ntailored just for you.",style: TextStyle(height: 1.5),presetFontSizes: [14,12],maxLines: 2,textAlign: TextAlign.center,),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  Row(children: [
                    AutoSizeText("Recommended",style: TextStyle(fontWeight: FontWeight.w600),presetFontSizes: [16,14],),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color:blueColor
                      ),
                      height: MediaQuery.of(context).size.height*0.045,
                      width: MediaQuery.of(context).size.width*0.35,
                      child: Center(child: AutoSizeText("Follow All",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14],),),
                    )
                  ],)
                ],),
              )
                  :SizedBox();
            }, separatorBuilder: (BuildContext context,int index){
              return Divider(thickness: 3,);
            }, itemCount: users.length+1),
          )
      );
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}
