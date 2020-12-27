import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';


class MultiSelectView extends StatelessWidget{
  static Route route(){
    return MaterialPageRoute(builder: (_)=>MultiSelectView());
  }
  final PageController _controller=PageController(
    keepPage: true,
    viewportFraction: 0.9
  );
  @override
  Widget build(BuildContext context){
    return ViewModelBuilder<PostCreationViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        builder: (context,model,child){
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(icon: Icon(Icons.arrow_forward_outlined), onPressed: (){
              model.changeMediumToFiles();
            })
          ],
        ),
        body: model.isBusy?Center(child: AppProgressIndication(),):PageView.builder(
          controller: _controller,
            itemCount: model.selectedMedia.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Padding(
                        padding:  EdgeInsets.symmetric(vertical: getHeigth(context, 0.1)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: model.selectedMedia[index].mediumType==MediumType.video?VideoView(data: model.selectedMedia[index],):Image(
                          image: ThumbnailProvider(
                              mediumId: model.selectedMedia[index].id,
                              mediumType: model.selectedMedia[index].mediumType,
                              width: MediaQuery.of(context).size.width.toInt(),
                              height: MediaQuery.of(context).size.height~/3,
                              highQuality: Platform.isIOS?true:false
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }
}

class VideoView extends StatefulWidget {
  final Medium data;
  VideoView({this.data});
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with AutomaticKeepAliveClientMixin{
  VideoPlayerController _controller;
  File file;

  initiateVideo()async{
    file=await widget.data.getFile();
    _controller = VideoPlayerController.file(
        file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  void initState() {
    super.initState();
    initiateVideo();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _controller?.value?.initialized!=null
        ? GestureDetector(
          onTap: (){
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              Center(
                child: _controller.value.isPlaying?SizedBox():Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black38),
                    child: Icon(Icons.play_arrow,color: Colors.white,size:50,)),
              )
            ],
          ),
        )
        : Container();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
