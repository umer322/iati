
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:stacked/stacked.dart';

import '../postcreation_viewmodel.dart';



class VideoThumbnailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostCreationViewModel>.nonReactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        builder: (context,model,child){
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.close,color: Colors.black,), onPressed: (){
              Navigator.pop(context);
            }),
            title: Text("Select Cover"),
            centerTitle: true,
            actions: [
              IconButton(icon: Icon(Icons.done,color: Colors.black,), onPressed: (){
                model.popView();
              })
            ],
          ),
          body: CoverView(),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }

}

class CoverView extends ViewModelWidget<PostCreationViewModel> {
  @override
  Widget build(BuildContext context, PostCreationViewModel viewModel) {
    return  Column(
      children: [
        Expanded(
            flex: 6,
            child:viewModel.getVideoThumbnails==null?SizedBox():Container(
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: MemoryImage(viewModel.selectedPost.localCoverImage==null?viewModel.getVideoThumbnails[0]:viewModel.selectedPost.localCoverImage),
                fit: BoxFit.cover,
              ),
            )),
        Expanded(
            flex: 1,
            child: SizedBox()),
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
          child: Row(children: [
            AutoSizeText("Select a cover",presetFontSizes: [18,16],)
          ],),
        )),
        Expanded(
            flex: 2,
            child: viewModel.getVideoThumbnails==null?Center(child: AppProgressIndication(),):Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.getVideoThumbnails.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        viewModel.selectCoverImageOfVideo(viewModel.getVideoThumbnails[index]);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        height: MediaQuery.of(context).size.height*0.08,
                        width: MediaQuery.of(context).size.height*0.1,
                        child: Image(
                          image: MemoryImage(viewModel.getVideoThumbnails[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            )),
        Expanded(
            flex: 1,
            child: SizedBox()),
      ],
    );
  }

}


