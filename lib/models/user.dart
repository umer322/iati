import 'package:iati/models/subscription.dart';

class AppUser{
  String id;
  String name;
  String userName;
  String email;
  String bio;
  String category;
  String imageUrl;
  DateTime birthDay;
  List<Subscription> subscriptionTypes;
  List<String> favoriteCategories;
  List<String> subscribers;
  List<String> subscriptions;
  List<String> followers;
  List<String> following;
  AppUser({this.birthDay,this.imageUrl,this.followers,this.favoriteCategories,this.subscribers,this.category,this.bio,this.email,this.userName,this.name,this.following,this.id,this.subscriptions});
  AppUser.fromJson(Map<String,dynamic> data,String id):
      id=id,
      name=data['name'],
      birthDay=data['birth_day']==null?null:DateTime.parse(data['birth_day']),
      userName=data['user_name'],
      email=data['email'],
      bio=data['bio'],
      imageUrl=data['image_url'],
      favoriteCategories=getFavoriteCategories(data['favorite_categories']??[]),
      category=data['category'],
      subscribers=getSubscribers(data['subscribers']??[]),
      subscriptions=getSubscribers(data['subscriptions']??[]),
      followers=getFollowers(data['followers']??[]),
      subscriptionTypes=getSubscriptionTypes(data['subscription_types']??[]),
      following=getFollowing(data['following']??[]);
  static List<String> getFavoriteCategories(List data){
    return data.map((e) => e.toString()).toList();
  }
  static List<String> getFollowing(List data){
    return data.map((e) => e.toString()).toList();
  }
  static List<String> getFollowers(List data){
    return data.map((e) => e.toString()).toList();
  }
  static List<String> getSubscribers(List data){
    return data.map((e) => e.toString()).toList();
  }

  static List<Subscription> getSubscriptionTypes(List data){
    return data.map((e) => Subscription.fromJson(Map.from(e))).toList();
  }

  List<Map> getDefaultSubscriptions(){
    return [
      Subscription(
        title: "Public",
        description: "Visible to everyone",
        limited: false
      ).toMap(),
      Subscription(
        title: "Subscribers Only",
        description: "Visible to all of your subscribers",
        limited: false
      ).toMap()
    ];
  }

  toMap(){
    return {
      "id":id,
      "name":name,
      "user_name":userName,
      "email":email,
      "bio":bio,
      "subscription_types":subscriptionTypes??getDefaultSubscriptions(),
      "image_url":imageUrl,
      "subscriptions":subscriptions,
      "birth_day":birthDay?.toIso8601String(),
      "category":category,
      'favorite_categories':favoriteCategories??[],
      "subscribers":subscribers??[],
      "followers":followers??[],
      "following":following??[]
    };
  }
}