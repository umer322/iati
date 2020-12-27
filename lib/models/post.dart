import 'dart:typed_data';
import 'package:iati/models/media_model.dart';
import 'package:iati/models/subscription.dart';

class Post{
  String id;
  String title;
  String userId;
  Uint8List localCoverImage;
  dynamic coverImage;
  List<MediaModel> fileUrls;
  String caption;
  List<String> hashTags;
  List<String> likes;
  int plays;
  DateTime time;
  String category;
  Subscription subscriptionType;
  String postLink;
  Post({this.id,this.subscriptionType,this.time,this.plays,this.likes,this.hashTags,this.caption,this.fileUrls,this.coverImage,this.userId,this.title,this.localCoverImage,this.category,this.postLink});
  Post.fromJson(Map<String,dynamic> data,String id):
      id=id,
      title=data['title'],
      userId=data['user_id'],
      coverImage=data['cover_image'],
      fileUrls=getFiles(data['file_urls']),
      category=data['category'],
      caption=data['caption'],
      postLink=data['post_link'],
      hashTags=getHashTags(data['hash_tags']??[]),
      likes=getLikes(data['likes']??[]),
      plays=data['plays'],
      time=DateTime.parse(data['time']),
      subscriptionType=Subscription.fromJson(data['subscription_type']);

  static List<MediaModel> getFiles(List data){
    return data.map((e) => MediaModel.fromJson(e)).toList();
  }
  static List<Map> getSubscribers(List data){
    return List<Map>.from(data);
  }

  static List<String> getHashTags(List data){
    return data.map((e) => e.toString()).toList();
  }
  static List<String> getLikes(List data){
    return data.map((e) => e.toString()).toList();
  }



  toMap(){
    return {
      "title":title,
      "cover_image":coverImage??localCoverImage,
      "file_urls":fileUrls?.map((e) => e.toJson())?.toList(),
      "user_id":userId,
      "caption":caption,
      "hash_tags":hashTags??[],
      "likes":likes??[],
      "category":category,
      'post_link':postLink,
      "plays":plays??0,
      "time":time.toIso8601String(),
      "subscription_type":subscriptionType.toMap()
    };
  }

}