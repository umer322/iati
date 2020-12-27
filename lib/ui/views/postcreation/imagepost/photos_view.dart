import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';

class PostPhotosView extends StatelessWidget{

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
      return Expanded(
        child: RefreshIndicator(
          onRefresh: ()async{
            await model.refresh();
            return;
          },
          child: model.images==null?Center(child: Text("No images to show"),):GridView.builder(
            key: PageStorageKey('pictures'),
              itemCount: model.images.items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemBuilder: (BuildContext context,int index){

            return GestureDetector(
              onTap: ()async{
              model.addMediaFiles(model.images.items[index]);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                 Image(image: ThumbnailProvider(
                     mediumId: model.images.items[index].id,
                     mediumType: MediumType.image,
                     width: MediaQuery.of(context).size.width~/4,
                     height: MediaQuery.of(context).size.width~/4,
                     highQuality: Platform.isIOS?true:false
                 ),fit: BoxFit.cover,),
                  Positioned(
                      top:10,
                      right:10,
                      child:  model.selectedMedia.contains(model.images.items[index])?AnimatedContainer(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(shape: BoxShape.circle,color: primaryColor),duration:Duration(milliseconds: 200),child: Center( child:Text("${model.selectedMedia.indexOf(model.images.items[index])+1}",style: TextStyle(color: Colors.white),))):Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color:Colors.grey.withOpacity(0.2),
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle
                        ),
                      ))
                ],
              ),
            );
          }),
        ),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }

}