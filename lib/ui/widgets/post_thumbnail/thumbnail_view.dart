import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iati/models/post.dart';
import 'package:iati/ui/widgets/post_thumbnail/thumbnail_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ThumbnailView extends StatelessWidget {
  final Post post;
 ThumbnailView({this.post});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ThumbnailViewModel>.nonReactive(builder:(context,model,child){
      return GestureDetector(
        onTap: (){
          print("coming here");
          model.goToPostPreview(post: post);
        },
        child: Stack(children: [
          Center(child: CachedNetworkImage(imageUrl: post.coverImage,fit: BoxFit.cover,)),
          post.fileUrls[0].isVideo?Positioned(
              top: 10,
              right: 10,
              child:Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color:Colors.grey),
                    shape: BoxShape.circle
                ),
                child: Center( child: Icon(Icons.play_arrow,color: Colors.black,size: 10,)),
              )):SizedBox(),
          post.fileUrls.length>1?Positioned(
            right: 10,
            bottom: 10,
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(5)),
                child: Icon(Icons.collections_outlined,color: Colors.white,size: 15,)),
          ):SizedBox()
        ],),
      );
    }, viewModelBuilder: ()=>ThumbnailViewModel());
  }
}
