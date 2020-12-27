

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iati/ui/views/postcreation/imagepost/photos_view.dart';
import 'package:iati/ui/views/postcreation/photovideotabs_viewmodel.dart';
import 'package:iati/ui/views/postcreation/videoposts/videos_view.dart';
import 'package:stacked/stacked.dart';

class VideoPhotoView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
   return ViewModelBuilder<PhotoVideoTabsViewModel>.reactive(builder: (context,model,child){
     return Expanded(
       child: Column(
         children: [
           Row(
             children: [
               Expanded(child: GestureDetector(
                 onTap: (){
                   model.setIndex(0);
                 },
                 child: AnimatedContainer(duration: Duration(milliseconds: 300,),
                   height: MediaQuery.of(context).size.height*0.06,decoration: BoxDecoration(border: Border(bottom: BorderSide(color: model.currentIndex==0?Colors.black:Colors.grey,width: 4))),child: Center(child: AutoSizeText("Videos",style: TextStyle(color:model.currentIndex==0?Colors.black:Colors.grey ),presetFontSizes: [18,16,14],),),),
               )),
               Expanded(child: GestureDetector(
                 onTap: (){
                   model.setIndex(1);
                 },
                 child: AnimatedContainer(duration: Duration(milliseconds: 300,),
                   height: MediaQuery.of(context).size.height*0.06,decoration: BoxDecoration(border: Border(bottom: BorderSide(color: model.currentIndex==1?Colors.black:Colors.grey,width: 4))),child: Center(child: AutoSizeText("Photos",style: TextStyle(color:model.currentIndex==1?Colors.black:Colors.grey ),presetFontSizes: [18,16,14],),),),
               )),
             ],
           ),
            getViewForIndex(model.currentIndex)
         ],
       ),
     );
   }, viewModelBuilder: ()=>PhotoVideoTabsViewModel());
  }
 Widget getViewForIndex(int index){
   switch(index){
     case 0:
      return PostVideoView();
     case 1:
       return PostPhotosView();
     default:
       return PostVideoView();

   }
 }
}