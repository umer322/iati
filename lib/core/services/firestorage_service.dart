import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:iati/models/media_model.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class FireStorageService{
  Future<String> uploadCoverImage(Uint8List file)async{
    String imageUrl;
    var rng = new Random();
    try{
      final Reference storageReference = FirebaseStorage.instance.ref().child("${file.first}${rng.nextInt(1000)}${rng.nextInt(1000)}${rng.nextInt(1000)}");
      final UploadTask uploadTask = storageReference.putData(file);

      final StreamSubscription<TaskSnapshot> streamSubscription =
      uploadTask.asStream().listen((event) {
        print('EVENT ${event.state}');
      });

      // Cancel your subscription when done.
      await uploadTask.whenComplete(() => streamSubscription.cancel());


      imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    }
    catch(e){
      print(e);
      return imageUrl;
    }
  }

  Future<List<MediaModel>> uploadMultipleFiles(List<MediaModel> assets) async {
    List<MediaModel> _imageUrls = List();
    var rng = new Random();
    try {
      for (int i = 0; i < assets.length; i++) {
        File file=File(assets[i].file);
        print(file.lengthSync());
        if(file.existsSync()){
          if(assets[i].isVideo){
            if(file.lengthSync()>5000000){
              MediaInfo mediaInfo = await VideoCompress.compressVideo(
                file.path,
                quality: VideoQuality.MediumQuality,
                deleteOrigin: false, // It's false by default
              );
              file=mediaInfo.file;
              print(mediaInfo.filesize);
            }
          }

          else{
            if(file.lengthSync()>100000){
              final dir = await path_provider.getTemporaryDirectory();
              final targetPath = dir.absolute.path + "/temp1.jpg";
              file = await FlutterImageCompress.compressAndGetFile(
                file.absolute.path,
                targetPath,
                minWidth: 1000,
                minHeight: (1000*1.1).toInt(),
                format: CompressFormat.jpeg,
                quality: 85,
              );
            }
          }

          final Reference storageReference = FirebaseStorage.instance.ref().child("${file.path.split("/").last}${rng.nextInt(1000)}${rng.nextInt(1000)}${rng.nextInt(1000)}");
          final UploadTask uploadTask = storageReference.putFile(file);

          final StreamSubscription<TaskSnapshot> streamSubscription =
          uploadTask.asStream().listen((event) {
            print('EVENT ${event.state}');
          });

          // Cancel your subscription when done.
          await uploadTask.whenComplete(() => streamSubscription.cancel());


          String imageUrl = await storageReference.getDownloadURL();
          MediaModel data=MediaModel(
              file: imageUrl,
              isVideo: assets[i].isVideo
          );
          _imageUrls.add(data);
        }
      }
      return _imageUrls;
    }
    catch (e) {
      print(e);
      return _imageUrls;
    }
  }

  Future<String> uploadFiles(String file)async{
    String imageUrl;
    var rng = new Random();
    try{
      final Reference storageReference = FirebaseStorage.instance.ref().child("${file.split("/").last}${rng.nextInt(1000)}${rng.nextInt(1000)}${rng.nextInt(1000)}");
      final UploadTask uploadTask = storageReference.putFile(File(file));

      final StreamSubscription<TaskSnapshot> streamSubscription =
      uploadTask.asStream().listen((event) {
        print('EVENT ${event.state}');
      });

      // Cancel your subscription when done.
      await uploadTask.whenComplete(() => streamSubscription.cancel());


      imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    }
    catch(e){
      print(e);
      return imageUrl;
    }
  }
}