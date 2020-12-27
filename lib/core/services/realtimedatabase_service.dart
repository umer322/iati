
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:iati/models/comment_model.dart';

class RealTimeDataBase{

  final StreamController<List<CommentModel>> _commentsList=StreamController.broadcast();
  final DatabaseReference _commentsReference=FirebaseDatabase.instance.reference().child('comments');

  final _postComments=List<CommentModel>();

  Stream listenToPostComments({@required String postId}){
    _postComments.clear();
    _commentsList.add([]);
    _listenToCommentAdded(postId);
    return _commentsList.stream;
  }

  _listenToCommentAdded(String postId){
    _commentsReference.child(postId).onValue.listen((event) {
      print(event.snapshot.value);
      _postComments.clear();
      if(event.snapshot.value!=null){
        Map<String,dynamic> data=Map.from(event.snapshot.value);
        data.forEach((key, value) {
          Map<String,dynamic> userComment=Map.from(value);
          _postComments.add(CommentModel.fromJson(userComment, key));
        });
        _postComments.sort((a,b)=>a.time.compareTo(b.time));
        _commentsList.add(_postComments);
      }else{
        _commentsList.add([]);
      }
    });
  }

  writeComment(CommentModel comment,String postId){
    _commentsReference.child(postId).push().set(comment.toJson());
  }

}