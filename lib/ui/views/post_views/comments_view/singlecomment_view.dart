

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/models/comment_model.dart';
import 'package:iati/ui/views/post_views/comments_view/singlecomment_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class SingleCommentView extends StatelessWidget{
  final CommentModel comment;
  SingleCommentView({Key key,this.comment}):super(key: key);
  @override
  Widget build(BuildContext context) {
     return ViewModelBuilder<SingleCommentViewModel>.reactive(
         onModelReady: (model){
           model.initialise(comment);
         },
         builder: (context,model,child){
       return Padding(
         padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.04),vertical: getWidth(context, 0.02)),
         child: Row(children: [
           model.commentUser==null?SizedBox(
             height: getWidth(context, 0.10),
             width: getWidth(context, 0.10),
           ):Container(
             height: getWidth(context, 0.10),
             width: getWidth(context, 0.10),
             decoration: BoxDecoration(
                 color: Colors.black,
                 shape: BoxShape.circle,
                 image: DecorationImage(
                     image: model.commentUser.imageUrl == null
                         ? AssetImage("assets/person.png")
                         : CachedNetworkImageProvider(
                         model.commentUser.imageUrl))),
           ),
           SizedBox(width: getWidth(context, 0.05),),
           Expanded(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 model.commentUser!=null?AutoSizeText(model.commentUser.name!=null?model.commentUser.name:"No Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),presetFontSizes: [16,14],):SizedBox(),
                 SizedBox(height: 5,),
                 AutoSizeText(model.currentComment.comment,style: TextStyle(color: Colors.grey),),
                 SizedBox(height: 5,),
                  Row(children: [
                  Text(showDate(model.currentComment.time),style: TextStyle(color: Colors.grey),),SizedBox(width: 8,),Text("${model.currentComment.likes==null?0:model.currentComment.likes.length} Likes",style: TextStyle(color: Colors.grey),),SizedBox(width: 8,),Text("Reply",style: TextStyle(color: Colors.grey),)
                  ],)
               ],
             ),
           ),
           IconButton(icon: Icon(Icons.favorite_border,color: Colors.grey,), onPressed: (){})
         ],),
       );
     }, viewModelBuilder: ()=>SingleCommentViewModel());
  }

  String showDate(DateTime time){
    if(time!=null){
      DateTime now=DateTime.now();
      if(now.difference(time).inSeconds<60){
        return "Just now";
      }
      else if(now.difference(time).inMinutes<60){
        return "${now.difference(time).inMinutes}m";
      }
      else if(now.difference(time).inHours<24){
        return "${now.difference(time).inHours}h";
      }
      else if(now.difference(time).inDays<30){
        return "${now.difference(time).inDays}d";
      }
      else{
        return DateFormat.MMMEd().format(time);
      }
    }else{
      return "";
    }
  }
}
