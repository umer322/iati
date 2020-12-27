import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MultiMediaService{

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
  Future<List<Album>> getImageAlbums()async{
    if(await Permission.storage.request().isGranted) {
      final List<Album> imageAlbums = await PhotoGallery.listAlbums(
          mediumType: MediumType.image
      );
      return imageAlbums;
    }
  }

  Future<List<Album>> getVideoAlbums()async{
    if(await Permission.storage.request().isGranted) {
      final List<Album> videoAlbums = await PhotoGallery.listAlbums(
          mediumType: MediumType.video
      );
      return videoAlbums;
    }
    }


  Future<MediaPage> getAllVideos(Album selectedAlbum)async{
    MediaPage page;

      try{
        final MediaPage imagePage = await selectedAlbum.listMedia(
          take: selectedAlbum.count,
        );

        page=imagePage;
        return page;
      }
      catch(e){
        print(e);
        return page;
      }
  }

  Future<MediaPage> getImagesList(Album selectedAlbum) async {
    MediaPage page;

      try{


//        Album allImages=imageAlbums.firstWhere((element) => element.id == "__ALL__");
        final MediaPage imagePage = await selectedAlbum.listMedia(
          take: selectedAlbum.count,
        );
        page=imagePage;
        return page;
      }
      catch(e){
        print(e);
        return page;
      }

  }

  Future<File> cropImageAndReturnFile(File file)async{
    File croppedFile = await ImageCropper.cropImage(
        sourcePath:file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
        ]
            : [
          CropAspectRatioPreset.square,

        ],
        compressQuality: 85,
        aspectRatio: CropAspectRatio(ratioX: 1,ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image View',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
            title: 'Image View',
            minimumAspectRatio: 3/2,
            resetAspectRatioEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            rotateButtonsHidden: true
        ));
    return croppedFile;
  }

  Future<Uint8List> compressImageAndReturnUintList(int size,File file)async{
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: size,
      minHeight: size,
      quality: 70,
    );
    return result;
  }

  Future<File> compressAndReturnFile(int size,File file)async{
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: size,
      minHeight: (size*1.1).toInt(),
      format: CompressFormat.jpeg,
      quality: 85,
    );
    return result;
  }
  Stream<List<Uint8List>> generateThumbnail(String video) async* {
    final String _videoPath = video;
    int videoDuration=await getVideoLength(File(video));

    double _eachPart = videoDuration / 10;
    print(_eachPart);

    List<Uint8List> _byteList = [];

    for (int i = 1; i <= 10; i++) {
      print((_eachPart * i).toInt());
      Uint8List _bytes;
      _bytes = await VideoThumbnail.thumbnailData(
        video: _videoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: (_eachPart * i).toInt(),
        quality: 80,
      );
      _byteList.add(_bytes);

      yield _byteList;
    }
  }

  Future<Uint8List> generateSingleThumbnail(String path)async{
    Uint8List _bytes;
    _bytes = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 80,
    );
    return _bytes;
  }

  Future<int> getVideoLength(File file)async{
    var  data=await _flutterFFprobe.getMediaInformation("${file.path}");
    return (double.parse(data.getMediaProperties()['duration'])*1000).toInt();
  }

}