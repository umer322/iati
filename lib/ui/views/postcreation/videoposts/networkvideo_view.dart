import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NetworkVideoView extends StatefulWidget {
  final String data;
  NetworkVideoView({this.data});
  @override
  _NetworkVideoViewState createState() => _NetworkVideoViewState();
}

class _NetworkVideoViewState extends State<NetworkVideoView> with AutomaticKeepAliveClientMixin{
  VideoPlayerController _controller;
  ChewieController chewieController;
  initiateVideo()async{
    _controller = VideoPlayerController.network(
       widget.data)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        chewieController = ChewieController(
          videoPlayerController: _controller,
        );
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
        ? VisibilityDetector(
      key: Key(widget.data),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if(mounted){
          if(visiblePercentage < 50){
            chewieController?.pause();
          }
        }
      },
          child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  width: getWidth(context, 1),
                  height: getWidth(context, 1),
                  child: chewieController==null?Center(child: AppProgressIndication(),):Chewie(
                    controller: chewieController,
                  ),
                ),
              ],
          ),
        )
        : Container();
  }
  @override
  void dispose() {
    _controller?.dispose();
    chewieController?.dispose();
    super.dispose();
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}