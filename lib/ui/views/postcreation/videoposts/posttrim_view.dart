import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimView extends StatefulWidget {
  final Trimmer _trimmer;
  final File file;
  VideoTrimView(this._trimmer,this.file);
  @override
  _VideoTrimViewState createState() => _VideoTrimViewState();
}

class _VideoTrimViewState extends State<VideoTrimView> {
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _progressVisibility = false;
  String trimmedFile;
  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await widget._trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue,outputFormat: FileFormat.mp4,storageDir: StorageDir.temporaryDirectory)
        .then((value) {
      trimmedFile=value;

      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  bool _isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostCreationViewModel>.nonReactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        builder: (context,model,child){
      return Scaffold(
        appBar: AppBar(title: Text("Edit Video"),
          actions: [
            FlatButton(onPressed: (){
              if(trimmedFile!=null){
                model.goToPostDetailView(video: trimmedFile);
              }
              else{
                model.goToPostDetailView(video: widget.file.path);
              }
            }, child:AutoSizeText("Next",presetFontSizes: [16,14],style: TextStyle(color: primaryColor),))
          ],
          centerTitle: true,),
        backgroundColor: Colors.white,
        body:Builder(
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: _progressVisibility,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),

                  Expanded(
                    child: VideoViewer(),
                  ),
                  Center(
                    child: TrimEditor(
                        viewerHeight: 50.0,
                        circlePaintColor:primaryColor,
                        circleSizeOnDrag: 10,
                        borderPaintColor: Colors.grey,
                        scrubberPaintColor: Colors.yellow,
                        circleSize: 8,
                        durationTextStyle: TextStyle(color: Colors.black),
                        viewerWidth: MediaQuery.of(context).size.width,
                        onChangeStart: (value) {
                          print(value);
                          setState(() {
                            _startValue = value;
                          });

                        },
                        onChangeEnd: (value) {
                          _endValue = value;
                        },
                        onChangePlaybackState: (value) {
                          _isPlaying = value;
                        }
                    ),
                  ),
                  FlatButton(
                    child: _isPlaying
                        ? Icon(
                      Icons.pause,
                      size: 80.0,
                      color: Colors.black,
                    )
                        : Icon(
                      Icons.play_arrow,
                      size: 80.0,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      bool playbackState =
                      await widget._trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      print(_endValue);
                      print(playbackState);
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                    child: Row(children: [
                      GestureDetector(
                        onTap: _progressVisibility
                            ? null
                            : () async {
                          _saveVideo().then((outputPath) {
                            trimmedFile=outputPath;
                            final snackBar = SnackBar(content: Text('Video Saved successfully'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        },
                        child: AutoSizeText("Trim",presetFontSizes: [18,16],style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: ()async{
                          if(trimmedFile!=null){
                            model.getListOfImages(trimmedFile);
                            model.goToVideoThumbnailsView();
                          }
                            else{
                              model.getListOfImages(widget.file.path);
                            model.goToVideoThumbnailsView();
                          }
                        },
                        child: AutoSizeText("Select a cover",presetFontSizes: [18,16],style: TextStyle(color: Colors.black),),
                      ),
                    ],),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }
}
