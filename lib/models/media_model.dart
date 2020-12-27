class MediaModel{
  String file;
  bool isVideo;

  MediaModel({this.file,this.isVideo});

  MediaModel.fromJson(Map<String,dynamic> data):
      file=data['file'],
      isVideo=data['is_video'];

  toJson(){
    return {
      "file":file,
      "is_video":isVideo
    };
  }
}