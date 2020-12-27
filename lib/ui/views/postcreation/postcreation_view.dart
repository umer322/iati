import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:iati/ui/views/postcreation/video_photo_view.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';


class PostCreationView extends StatelessWidget {
  static Route route(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>PostCreationView(),
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
    },);
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostCreationViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        onModelReady: (model){
          model.onInit();
        },
        builder: (context,model,child){
      return Scaffold(
        body: SafeArea(
          bottom: false,
      child: model.isBusy?Center(child: AppProgressIndication()):Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: getHeigth(context, 0.015)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
               GestureDetector(
                 onTap: (){
                   model.popView();
                 },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                   child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                 ),
               ),
              GestureDetector(
                onTap: (){
                  model.selectAlbum();
                },
                child: Row(children: [
                  AutoSizeText(model.selectedImageAlbum?.name??model.selectedVideoAlbum?.name,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                  SizedBox(width: 3,),
                  Icon(Icons.keyboard_arrow_down,color: Colors.black,)
                ],),
              ),
              IconButton(icon: Icon(Icons.collections_outlined,color: model.selectMultipleFiles?primaryColor:Colors.grey,), onPressed: (){
                model.toggleMultiSelect();
              })
            ]),
          ),
         VideoPhotoView(),
         AnimatedContainer(
            height: model.selectedMedia.length==0?0:getHeigth(context, 0.07),
            duration: Duration(milliseconds: 500),
            child:
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                  itemCount: model.selectedMedia.length,
                  itemBuilder: (BuildContext context,int index){
                return Container(
                    margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.black12
                  ),
                  height: getWidth(context, 0.9),
                  width: getWidth(context, 0.1),
                  child: Stack(children: [
                    Center(
                      child: Image(
                        fit: BoxFit.cover,
                        image: ThumbnailProvider(
                            mediumId: model.selectedMedia[index].id,
                            mediumType: MediumType.video,
                            width: MediaQuery.of(context).size.width~/4,
                            height: MediaQuery.of(context).size.width~/4,
                            highQuality: Platform.isIOS?true:false
                        ),
                      ),
                    ),
                    Positioned(
                        top:0,
                        right:0,
                        child: GestureDetector(
                          onTap:(){
                            model.removeMediaFile(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black26),
                      child: Center(child: Icon(Icons.close,color: Colors.white,size: 13,),),
                    ),
                        ))
                  ],)
                );
              })
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height:model.selectMultipleFiles?getHeigth(context, 0.07):0,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black26))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              AutoSizeText("You can select both videos and images",style: TextStyle(color: Colors.black54),),
              RaisedButton(onPressed: model.selectedMedia.length>0?(){
                model.goToMultiSelectScreen();
              }:null,
                color: model.selectedMedia.length>0?primaryColor:Colors.white,
                child: Text("Next",style: TextStyle(color: model.selectedMedia.length>0?Colors.white:Colors.black54),),)
            ],),
          )
        ],
      ),
        ),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }
}
