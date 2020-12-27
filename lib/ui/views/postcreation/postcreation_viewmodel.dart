

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/dynamiclinks_service.dart';
import 'package:iati/core/services/firestorage_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/core/services/multimediaservice.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/media_model.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/subscription.dart';
import 'package:iati/models/user.dart';
import 'package:iati/routes/routes_const.dart';
import 'package:iati/ui/views/postcreation/multiselect_view.dart';
import 'package:iati/ui/views/postcreation/videoposts/posttrim_view.dart';
import 'package:iati/ui/views/postcreation/videoposts/videothumbnails_view.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_trimmer/video_trimmer.dart';

class PostCreationViewModel extends BaseViewModel{
    final NavigationService _navigationService = locator<NavigationService>();
    final MultiMediaService _multiMediaService =locator<MultiMediaService>();
    final SnackbarService _snackBarService = locator<SnackbarService>();
    final FireStorageService _fireStorageService =locator<FireStorageService>();
    final FirestoreService _firestoreService=locator<FirestoreService>();
    final AuthService _authServices = locator<AuthService>();

    bool selectMultipleFiles=false;
    List<Medium> selectedMedia=[];


    AppUser get currentUser=>_authServices.currentUser;
    int selectedIndex=1;
    MediaPage images;
    List<Map> imagesMap;
    MediaPage videos;
    Album selectedImageAlbum;
    Album selectedVideoAlbum;
    List<Album> imageAlbums;
    List<Album> videoAlbums;
    List<Album> allAlbums;
    String imagePageError;
    int videoLength;
    String videoPageError;
    List<Uint8List> getVideoThumbnails;
    Post selectedPost=Post();

    final Trimmer _trimmer = Trimmer();
    Stream<List<Uint8List>>  generateThumbnails({@required String videoPath})=>_multiMediaService.generateThumbnail(videoPath);
    getListOfImages(String videoPath){
        _multiMediaService.generateThumbnail(videoPath).listen((event) {
            getVideoThumbnails=[];
           getVideoThumbnails=event;
           notifyListeners();
        });
    }

    toggleMultiSelect(){
        if(selectMultipleFiles){
            selectedMedia=[];
        }
        selectMultipleFiles=!selectMultipleFiles;
        notifyListeners();
    }
    onInit()async{
        setBusy(true);
        imageAlbums=await _multiMediaService.getImageAlbums();
        videoAlbums=await _multiMediaService.getVideoAlbums();
        allAlbums=[...imageAlbums,...videoAlbums];
        selectedImageAlbum=imageAlbums.firstWhere((element) => element.id=="__ALL__");
        selectedVideoAlbum=videoAlbums.firstWhere((element) => element.id=="__ALL__");

        images=await _multiMediaService.getImagesList(selectedImageAlbum);
        videos=await _multiMediaService.getAllVideos(selectedVideoAlbum);
        notifyListeners();
        if(images.items.length==0){
            print("updating videos");
            onInit();
        }
       setBusy(false);
    }


    selectAlbum()async{
        var data=await _navigationService.navigateTo(selectAlbumView);
        if(data!=null){
            selectedImageAlbum=imageAlbums.firstWhere((element) => element.id==data,orElse: ()=>null);
            selectedVideoAlbum=videoAlbums.firstWhere((element) => element.id==data,orElse: ()=>null);
            if(selectedImageAlbum!=null){
                images=await _multiMediaService.getImagesList(selectedImageAlbum);
            }
            else{
                images=null;
            }
            if(selectedVideoAlbum!=null){
                videos=await _multiMediaService.getAllVideos(selectedVideoAlbum);
            }
            else{
             videos=null;
            }

            notifyListeners();
        }
    }

    popView(){
        _navigationService.back();
    }



    addMediaFiles(Medium data){
       if(selectMultipleFiles){
           if(selectedMedia.contains(data)){
               selectedMedia.remove(data);
           }
           else{
               selectedMedia.add(data);
           }
           notifyListeners();
       }else{
           if(data.mediumType==MediumType.video){
               selectVideoAndGoToTrimView(data);
           }
           else{
               selectImageAndGoToCropView(data);
           }
       }
    }

    removeMediaFile(int index){
        selectedMedia.removeAt(index);
        notifyListeners();
    }

    goToMultiSelectScreen(){
        selectedPost=Post();
        _navigationService.navigateToView(MultiSelectView());
    }

    selectVideoAndGoToTrimView(Medium medium)async{
        print("coming here");
        setBusy(true);
        selectedPost=Post();
        getVideoThumbnails=null;

        try{
            File file=await medium.getFile();
            await _trimmer.loadVideo(videoFile: file);
            selectedPost.fileUrls=List<MediaModel>();
            selectedPost.fileUrls.add(MediaModel());
           selectedPost.fileUrls[0].isVideo=true;
           videoLength=await _multiMediaService.getVideoLength(file);
           setBusy(false);
           _navigationService.navigateToView(VideoTrimView(_trimmer, file));
        }
        catch(e){
            _snackBarService.showSnackbar(message: "Error processing this video file");
            setBusy(false);
        }


    }
    goToPostDetailView({@required String video})async{
        setBusy(true);
        if(selectedPost.localCoverImage==null){
            selectedPost.localCoverImage=await _multiMediaService.generateSingleThumbnail(video);
        }
        selectedPost.fileUrls[0].file=video;
        selectedPost.fileUrls[0].isVideo=true;
        selectedPost.userId=currentUser.id;
        setBusy(false);
        _navigationService.navigateTo(postCreationDetailView);
    }
    selectCategoryAlert(){
        _snackBarService.showSnackbar(message: "Select category for your post");
    }
    selectImageAndGoToCropView(Medium medium)async{
            setBusy(true);
            selectedPost=Post();
            selectedPost.fileUrls=List<MediaModel>();
            selectedPost.fileUrls.add(MediaModel());
            selectedPost.fileUrls[0].isVideo=false;
            File file=await medium.getFile();
            File croppedFile =await _multiMediaService.cropImageAndReturnFile(file);
            if(croppedFile!=null){
                Uint8List compressCoverImage=await _multiMediaService.compressImageAndReturnUintList(400,croppedFile);
                selectedPost.localCoverImage=compressCoverImage;
                if(croppedFile.lengthSync()>100000){
                    File compressedFile=await _multiMediaService.compressAndReturnFile(1000, croppedFile);
                    selectedPost.fileUrls[0].file=compressedFile.path;
                    selectedPost.fileUrls[0].isVideo=false;
                }else{
                    selectedPost.fileUrls[0].file=croppedFile.path;
                    selectedPost.fileUrls[0].isVideo=false;
                }

                selectedPost.userId=currentUser.id;
                setBusy(false);
                _navigationService.navigateTo(postCreationDetailView);
            }else{
                selectedPost=Post();
                setBusy(false);
            }
    }

    Subscription setSubscriptionType(){
        return currentUser.subscriptionTypes.firstWhere((element) => element.title=="Public");
    }


    Future uploadPost()async{
            _snackBarService.showSnackbar(message: "Your post will be uploaded soon.");
            await Future.delayed(Duration(seconds: 2));
            _navigationService.popUntil((route) => route.settings.name=="HomePage");
            selectedPost.time=DateTime.now();
            String coverUrl=await _fireStorageService.uploadCoverImage(selectedPost.localCoverImage);
            selectedPost.coverImage=coverUrl;
            print("coming here");
            List<MediaModel> fileUrl=await _fireStorageService.uploadMultipleFiles(selectedPost.fileUrls);
            selectedPost.fileUrls=fileUrl;
            _firestoreService.createPost(post: selectedPost);
            _snackBarService.showSnackbar(message: "Your post has been uploaded.");
    }
    selectCoverImageOfVideo(Uint8List data){
        selectedPost.localCoverImage=data;
        notifyListeners();
    }
    goToVideoThumbnailsView(){
        _navigationService.navigateToView(VideoThumbnailsView());
    }

    refresh()async{
        images=await _multiMediaService.getImagesList(selectedImageAlbum);
        videos=await _multiMediaService.getAllVideos(selectedVideoAlbum);
        if(images.items.length==0){
            onInit();
        }
        notifyListeners();
    }

    Future<List<MediaModel>> getFiles()async{
        List<MediaModel> files=[];
        for (Medium i in selectedMedia){
            File file=await i.getFile();
            bool isVideo=i.mediumType==MediumType.video;
            files.add(MediaModel(file: file.path,isVideo: isVideo));
        }
        return files;
    }
    changeMediumToFiles()async{
        setBusy(true);
        List<MediaModel> data=await getFiles();
        selectedPost.fileUrls=data;
        if(selectedPost.localCoverImage==null){
            if(data[0].isVideo){
                selectedPost.localCoverImage=await _multiMediaService.generateSingleThumbnail(data[0].file);
            }
            else{
                Uint8List compressCoverImage=await _multiMediaService.compressImageAndReturnUintList(400,File(data[0].file));
                selectedPost.localCoverImage=compressCoverImage;
            }
        }
        selectedPost.userId=currentUser.id;
        setBusy(false);
        _navigationService.navigateTo(postCreationDetailView);
    }
}