import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';

class PostVideoView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostCreationViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,

        builder: (context,model,child){
          return Expanded(
            child: RefreshIndicator(
              onRefresh: ()async{
                await model.refresh();
                return;
              },
              child: model.videos==null?Center(child: Text("No videos to show"),):GridView.builder(
                  key: PageStorageKey('videos'),
                  itemCount: model.videos.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,crossAxisSpacing: 2,mainAxisSpacing: 2), itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  onTap: ()async{
                  model.addMediaFiles(model.videos.items[index]);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                     Image(
                        fit: BoxFit.cover,
                        image: ThumbnailProvider(
                            mediumId: model.videos.items[index].id,
                            mediumType: MediumType.video,
                            width: MediaQuery.of(context).size.width~/4,
                            height: MediaQuery.of(context).size.width~/4,
                            highQuality: Platform.isIOS?true:false
                        ),
                      ),
                      Positioned(
                          top:10,
                          right:10,
                          child:  model.selectedMedia.contains(model.videos.items[index])?AnimatedContainer(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: primaryColor),duration:Duration(milliseconds: 200),child: Center( child:Text("${model.selectedMedia.indexOf(model.videos.items[index])+1}",style: TextStyle(color: Colors.white),))):Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color:Colors.grey.withOpacity(0.2),
                                border: Border.all(color: Colors.grey),
                                shape: BoxShape.circle
                            ),
                          )),
                      Positioned(
                          right:10,
                          bottom:10,
                          child: Container(

                            height: 15,
                            child: AutoSizeText("${Duration(milliseconds: model.videos.items[index].duration).toMinutesSeconds()}",style: TextStyle(color: Colors.white),),
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

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String toMinutesSeconds(){
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inMinutes)}:$twoDigitSeconds";
  }
  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}