
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';

class FirestoreService{
  dispose(){
    _currentUserPostsList?.close();
    _timeLinePosts?.close();
    _getSuggestedUsers?.close();
    _userPosts?.close();
  }


  final CollectionReference _userCollectionReference=FirebaseFirestore.instance.collection("users");
  final CollectionReference _postCollectionReference=FirebaseFirestore.instance.collection("posts");


  final StreamController<List<Post>> _currentUserPostsList=StreamController.broadcast();
  final StreamController<List<Post>> _timeLinePosts=StreamController.broadcast();
  final StreamController<List<AppUser>> _getSuggestedUsers=StreamController.broadcast();
  final StreamController<List<Post>> _userPosts=StreamController.broadcast();

  DocumentSnapshot _lastUserPostDocument;
  DocumentSnapshot _lastCurrentUserPostDocument;
  DocumentSnapshot _lastTimeLinePostDocument;
  DocumentSnapshot _lastSuggestedUserDoc;


  bool _hasMoreUserPosts=true;
  bool _hasMoreTimeLinePosts=true;
  bool _hasMoreCurrentUserPosts=true;
  bool _hasMoreSuggestedUsers=true;

  List<List<Post>> _allUserPosts=List<List<Post>>();
  List<List<Post>> _allCurrentUserPosts=List<List<Post>>();
  List<List<Post>> _allTimeLinePosts=List<List<Post>>();
  List<List<AppUser>> _allSuggestedUsers=List<List<AppUser>>();
  
  
  Stream listenToSuggestedUsers({@required String userId}){
    _hasMoreSuggestedUsers=true;
    _lastSuggestedUserDoc=null;
    _allSuggestedUsers=List<List<AppUser>>();
    _getSuggestedUsers.add([]);
    _requestSuggestedUsers(userId: userId);
    return _getSuggestedUsers.stream;
  }

  Stream listenToCurrentUserPosts({@required String userId}){
    _hasMoreCurrentUserPosts=true;
    _lastCurrentUserPostDocument=null;
    _allCurrentUserPosts.clear();
    _currentUserPostsList.add([]);
    _requestCurrentUserPosts(userId: userId);
    return _currentUserPostsList.stream;
  }

  Stream listenToSearchedUserPosts({@required String userId}){
    _lastUserPostDocument=null;
    _hasMoreUserPosts=true;
    _allUserPosts.clear();
    _userPosts.add([]);
    _requestSearchedUserPosts(userId: userId);
    return _userPosts.stream;
  }

  Stream<List<Post>> listenToTimeLinePosts({@required AppUser user}){
    _requestTimeLinePostData(user: user);
    return _timeLinePosts.stream;
  }

  _requestSuggestedUsers({@required String userId}){

    Query allSuggestedUsersQuery=_userCollectionReference.limit(10);
    print(_lastSuggestedUserDoc);
    if(_lastSuggestedUserDoc!=null){
      allSuggestedUsersQuery=allSuggestedUsersQuery.startAfterDocument(_lastSuggestedUserDoc);
    }

    if(!_hasMoreSuggestedUsers)return;

    var currentRequestIndex=_allSuggestedUsers.length;

    allSuggestedUsersQuery.snapshots().listen((event) {
      print("getting users");
      print(event.docs.length);
      if(event.docs.length==0 && _allSuggestedUsers.length==0){
        _getSuggestedUsers.add([]);
        return;
      }
      if(event.docs.isNotEmpty){
        var suggestedUsers=event.docs.map((e) => AppUser.fromJson(e.data(),e.id)).toList();
        var pageExists=currentRequestIndex < _allSuggestedUsers.length;
        if(pageExists){
          _allSuggestedUsers[currentRequestIndex]=suggestedUsers;
        }
        else{
          _allSuggestedUsers.add(suggestedUsers);
        }
        var allUsers=_allSuggestedUsers.fold(List<AppUser>(), (previousValue, element) => previousValue..addAll(element));
        _getSuggestedUsers.add(allUsers);
        if(currentRequestIndex==_allSuggestedUsers.length-1){
          _lastSuggestedUserDoc=event.docs.last;
        }
        _hasMoreSuggestedUsers=suggestedUsers.length==10;
      }
    });

  }
  
  
  _requestTimeLinePostData({@required AppUser user}){
    Query timeLinePostsQuery;
      List<String> ids=user.following.length>9?user.following.sublist(0,9):user.following;
      ids.add(user.id);
      print("followed user ${ids.length}");
      timeLinePostsQuery=_postCollectionReference.where("user_id",whereIn: ids).orderBy("time",descending: true).limit(5);
    if(_lastTimeLinePostDocument!=null){
      timeLinePostsQuery=timeLinePostsQuery.startAfterDocument(_lastTimeLinePostDocument);
    }
    var currentRequestIndex=_allTimeLinePosts.length;

    if(!_hasMoreTimeLinePosts)return;
    timeLinePostsQuery.snapshots().listen((event) {
      print(event.docs.length);
      if(event.docs.length==0 && _allTimeLinePosts.length==0){
        _timeLinePosts.add([]);
        return;
      }
     if(event.docs.isNotEmpty){
       var currentTimeLinePosts=event.docs.map((e) => Post.fromJson(e.data(), e.id)).toList();
       var pageExists=currentRequestIndex < _allTimeLinePosts.length;

       if(pageExists){
         _allTimeLinePosts[currentRequestIndex]=currentTimeLinePosts;
       }
       else{
         _allTimeLinePosts.add(currentTimeLinePosts);
       }
       var allTimeLinePosts=_allTimeLinePosts.fold(List<Post>(), (previousValue, element) => previousValue..addAll(element));
       _timeLinePosts.add(allTimeLinePosts);
       if(currentRequestIndex == _allTimeLinePosts.length-1){
         _lastTimeLinePostDocument=event.docs.last;
       }
       _hasMoreTimeLinePosts=currentTimeLinePosts.length==5;
     }
    });
  }

  _requestSearchedUserPosts({@required String userId}) {

    var userPostQuery= _postCollectionReference.where("user_id",isEqualTo: userId).orderBy("time",descending: true).limit(20);
    if(_lastUserPostDocument!=null){
      userPostQuery=userPostQuery.startAfterDocument(_lastUserPostDocument);
    }

    if(!_hasMoreUserPosts) return;
    var currentRequestIndex = _allUserPosts.length;
    userPostQuery.snapshots().listen((event) {
      print("posts ${event.docs.length}");
      if(_allUserPosts.length==0 && event.docs.length==0){
        _userPosts.add([]);
        return;
      }
      if(event.docs.isNotEmpty){
        var currentUserPosts=event.docs.map((e)=>Post.fromJson(e.data(), e.id)).toList();
        var pageExists=currentRequestIndex < _allUserPosts.length;
        if(pageExists){
          _allUserPosts[currentRequestIndex]=currentUserPosts;
        }
        else{
          _allUserPosts.add(currentUserPosts);
        }

        var allPosts=_allUserPosts.fold<List<Post>>(List<Post>(), (previousValue, element) => previousValue..addAll(element));
        _userPosts.add(allPosts);

        if(currentRequestIndex==_allUserPosts.length-1){
          _lastUserPostDocument=event.docs.last;
        }
        _hasMoreUserPosts = currentUserPosts.length==20;
      }
    });
  }

  _requestCurrentUserPosts({@required String userId}) {

    var userPostQuery= _postCollectionReference.where("user_id",isEqualTo: userId).orderBy("time",descending: true).limit(20);
    if(_lastCurrentUserPostDocument!=null){
      userPostQuery=userPostQuery.startAfterDocument(_lastCurrentUserPostDocument);
    }

    if(!_hasMoreCurrentUserPosts) return;
    var currentRequestIndex = _allCurrentUserPosts.length;
    userPostQuery.snapshots().listen((event) {
      print("posts ${event.docs.length}");
      if(_allCurrentUserPosts.length==0 && event.docs.length==0){
        _currentUserPostsList.add([]);
        return;
      }
      if(event.docs.isNotEmpty){
        var currentUserPosts=event.docs.map((e)=>Post.fromJson(e.data(), e.id)).toList();
        var pageExists=currentRequestIndex < _allCurrentUserPosts.length;
        if(pageExists){
          _allCurrentUserPosts[currentRequestIndex]=currentUserPosts;
        }
        else{
          _allCurrentUserPosts.add(currentUserPosts);
        }

        var allPosts=_allCurrentUserPosts.fold<List<Post>>(List<Post>(), (previousValue, element) => previousValue..addAll(element));
        _currentUserPostsList.add(allPosts);

        if(currentRequestIndex==_allCurrentUserPosts.length-1){
          _lastCurrentUserPostDocument=event.docs.last;
        }
        _hasMoreCurrentUserPosts = currentUserPosts.length==20;
      }
    });
  }


  requestMoreUserPosts({@required String userId})=>_requestSearchedUserPosts(userId: userId);

  requestMoreTimeLineData({@required AppUser user})=>_requestTimeLinePostData(user: user);

  requestMoreSuggestedUserData({@required String userId})=>_requestSuggestedUsers(userId: userId);

  requestMoreCurrentUserData({@required String userId})=>_requestCurrentUserPosts(userId: userId);


  Future createNewUser({@required AppUser user,@required String id})async{

    try{
      user.id=id;
      await _userCollectionReference.doc(id).set(user.toMap());
    }catch(e){
        return e.message;
    }
  }

  Future getSinglePost(String postId)async{
    try{
      var postData = await _postCollectionReference.doc(postId).get();
      if(postData.exists){
       return Post.fromJson(postData.data(), postData.id);
      }
      else{
        return null;
      }
    }
    catch(e){
      return e.message;
    }
  }

  Future getUser(String uid)async{
    print("coming here to update user");
    try{
      var userData = await _userCollectionReference.doc(uid).get();
      if(userData.exists){
        return AppUser.fromJson(userData.data(),userData.id);
      }
      else{
        return null;
      }
    }
    catch(e){
      return e.message;
    }
  }

  Future<void> deletePost({@required String postId})async{
   await _postCollectionReference.doc(postId).delete();
  }
  Future<void> createPost({@required Post post})async{
    DocumentReference postDoc=_postCollectionReference.doc();
    await postDoc.set(post.toMap());
  }



  Future updateUser({@required AppUser user})async{
      try{
        await _userCollectionReference.doc(user.id).update(user.toMap());
      }
      catch(e){
        return e.message;
      }
  }

  Future<bool> userExists(String id)async{
    var userData=await _userCollectionReference.doc(id).get();
    if(userData.exists){
      return true;
    }
    else{
      return false;
    }
  }

  Future editPost(Post post)async{
    try{
      _postCollectionReference.doc(post.id).update({
        "title":post.title,
        "caption":post.caption,
        "hash_tags":post.hashTags,
        "subscription_type":post.subscriptionType.toMap()
      }).catchError((e){
        print(e);
      });
    }
    catch(e){
      print(e);
    }
  }

  updatePostLink(String postId,String url){
    _postCollectionReference.doc(postId).update({
      "post_link":url
    });
  }

   followUser(String userId,String currentUserId){
    _userCollectionReference.doc(userId).update({
      "followers":FieldValue.arrayUnion([currentUserId])
    });
    _userCollectionReference.doc(currentUserId).update({
      "following":FieldValue.arrayUnion([userId])
    });
  }


  likePost({@required String postId,@required String userId}){
    _postCollectionReference.doc(postId).update({
      "likes":FieldValue.arrayUnion([userId])
    });
  }

  unLikePost({@required String postId,@required String userId}){
    _postCollectionReference.doc(postId).update({
      "likes":FieldValue.arrayRemove([userId])
    });
  }

  unFollowUser(String userId,String currentUserId){
    _userCollectionReference.doc(userId).update({
      "followers":FieldValue.arrayRemove([currentUserId])
    });
    _userCollectionReference.doc(currentUserId).update({
      "following":FieldValue.arrayRemove([userId])
    });
  }
}