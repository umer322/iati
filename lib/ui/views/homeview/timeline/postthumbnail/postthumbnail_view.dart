
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/models/post.dart';
import 'package:iati/ui/views/homeview/timeline/postthumbnail/postthumbnail_viewmodel.dart';
import 'package:iati/ui/views/postcreation/multiselect_view.dart';
import 'package:iati/ui/views/postcreation/videoposts/networkvideo_view.dart';
import 'package:iati/ui/widgets/app_dialog_box.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:stacked/stacked.dart';

class PostThumbnailView extends StatefulWidget {
  final Post post;
  PostThumbnailView({this.post});

  @override
  _PostThumbnailViewState createState() => _PostThumbnailViewState();
}

class _PostThumbnailViewState extends State<PostThumbnailView> with AutomaticKeepAliveClientMixin<PostThumbnailView>{
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<PostThumbnailViewModel>.reactive(
        onModelReady: (model){
          model.listenToData(post: widget.post, userID: widget.post.userId);
        },
        builder: (context,model,child){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(context, 0.05),
                vertical: getWidth(context, 0.03)),
            child: model.postUser==null?SizedBox():Row(
              children: [
                GestureDetector(
                  onTap:(){
                    model.goToUserProfile();
                  },
                  child: Container(
                    height: getWidth(context, 0.12),
                    width: getWidth(context, 0.12),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: model.postUser.imageUrl == null
                                ? AssetImage("assets/person.png")
                                : CachedNetworkImageProvider(
                                model.postUser.imageUrl))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: (){
                    model.goToUserProfile();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        model.postUser.name != null
                            ? model.postUser.name
                            : "Shinobi Ninja",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        presetFontSizes: [18, 16, 14],
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AutoSizeText(
                        DateFormat.yMMMMd()
                            .format(model.currentPost.time),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                    height: getWidth(context, 0.08),
                    width: getWidth(context, 0.08),
                    child: PostOptions())
              ],
            ),
          ),
          model.currentPost.fileUrls.length==0?SizedBox():model.currentPost.fileUrls.length>1?Container(
            width: getWidth(context, 1),
            height: getWidth(context, 1),
            child: Stack(
              fit: StackFit.expand,
              children: [
              Container(
                width: getWidth(context, 1),
                height: getWidth(context, 1),
                child: PageView.builder(
                    itemCount: model.currentPost.fileUrls.length,
                    itemBuilder: (context,index){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        model.currentPost.fileUrls[index].isVideo?Container(
                            width: getWidth(context, 1),
                            height: getWidth(context, 1),
                            child: NetworkVideoView(data: model.currentPost.fileUrls[index].file,)):
                        Expanded(
                          child: CachedNetworkImage(
                          imageUrl: model.currentPost.fileUrls[index].file,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                      ),
                        ),
                      Row(children: [

                      ],)
                    ],
                  );
                }),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(5)),
                    child: Icon(Icons.collections_outlined,color: Colors.white,)),
              )
            ],),
          ):Container(
            width: getWidth(context, 1),
            height: getWidth(context, 1),
            child: model.currentPost.fileUrls[0].isVideo? model.chewieController==null?Center(child: SizedBox(),):Chewie(
              controller: model.chewieController,
            ):CachedNetworkImage(
              imageUrl: model.currentPost.fileUrls[0].file,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(context, 0.05),
                vertical: getWidth(context, 0.03)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  model.currentPost.title,
                  presetFontSizes: [20, 18, 16],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: getHeigth(context, 0.01),
                ),
                model.currentPost.caption != null
                    ? model.hasLongCaption? model.longCaption?AutoSizeText.rich(TextSpan(
                    children: [
                      TextSpan(text: model.currentPost.caption.substring(0,90)),
                      TextSpan(
                          text: "... more",
                          style: TextStyle(color: Colors.grey),
                          recognizer: TapGestureRecognizer()..onTap=()=>model.toggleCaption(false)
                      )
                    ]
                )):AutoSizeText.rich(TextSpan(
                    children: [
                      TextSpan(text: model.currentPost.caption),
                      TextSpan(
                          text: "less",
                          style: TextStyle(color: Colors.grey),
                          recognizer: TapGestureRecognizer()..onTap=()=>model.toggleCaption(true)
                      )
                    ]
                )):AutoSizeText(model.currentPost.caption)
                    : SizedBox(),
                Divider(),
                Row(
                  children: [
                    Row(
                      children: [
                        LikeButton(
                          likeCountAnimationType: LikeCountAnimationType.none,
                          size: getHeigth(context, 0.05),
                          circleColor: CircleColor(
                              start: Color(0xff00ddff),
                              end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isLiked
                                  ? primaryColor
                                  : Colors.grey,
                              size: getHeigth(context, 0.04),
                            );
                          },
                          onTap: (bool val)async{
                            if(val){
                              await model.unLikePost();
                            }
                            else{
                              await model.likePost();
                            }
                            return model.isLiked;
                          },
                          likeCount:
                          model.currentPost.likes.length,
                          countBuilder: (int count, bool isLiked,
                              String text) {
                            var color = isLiked
                                ? primaryColor
                                : Colors.grey;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "love",
                                style: TextStyle(color: color),
                              );
                            } else
                              result = Text(
                                text,
                                style: TextStyle(color: color),
                              );
                            return result;
                          },
                          isLiked: model.isLiked
                              ? true
                              : false,
                        ),
                        SizedBox(
                          width: getWidth(context, 0.05),
                        ),
                        GestureDetector(
                          onTap: (){
                            model.goToCommentsView();
                          },
                          child: Container(
                              height: getHeigth(context, 0.04),
                              width: getHeigth(context, 0.04),
                              child: SvgPicture.asset(
                                "assets/icons/Comment.svg",
                                color: Colors.grey,
                              )),
                        ),
                        SizedBox(
                          width: getWidth(context, 0.03),
                        ),
                        AutoSizeText(
                          "${0}",
                          presetFontSizes: [18, 16],
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        model.goToCommentsView();
                      },
                      child: AutoSizeText(
                        "View all ${0} comments",
                        presetFontSizes: [16, 14],
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      );
    }, viewModelBuilder: ()=>PostThumbnailViewModel());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class PostOptions extends ViewModelWidget<PostThumbnailViewModel>{
  @override
  Widget build(BuildContext context, PostThumbnailViewModel model) {
    return IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: () {
          Platform.isIOS
              ? showCupertinoModalPopup(
              context: context,
              builder: (_) {
                return CupertinoActionSheet(
                  actions: model.currentPost.userId==model.currentUser.id?[
                    CupertinoActionSheetAction(
                      child: Text(
                        'Copy Link',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        model.popView();
                        model.copyPostLink();

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        model.popView();
                        model.editPost();
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Share',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        model.popView();
                        model.sharePost();
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Turn Off Commenting',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {
                        model.popView();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AppDialogBox(
                                  title: "Delete post",
                                  content:
                                  "Are you sure you want to delete this post?",
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          model.popView();
                                          model.deletePost();
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: primaryColor),
                                        )),
                                    FlatButton(
                                        onPressed: () {
                                          model.popView();
                                        },
                                        child: Text("Cancel"))
                                  ]);
                            });
                      },
                    )
                  ]:[CupertinoActionSheetAction(
                  child: Text(
                  'Copy Link',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  model.popView();
                  model.copyPostLink();
                },
                ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Share',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                          model.sharePost();
                      },
                    ),],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              })
              : showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)) ),
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Wrap(
                    children:model.currentPost.userId==model.currentUser.id?[
                      ListTile(
                          leading:
                          Icon(Icons.copy, color: primaryColor),
                          title: Text('Copy Link'),
                          onTap: () {
                            model.copyPostLink();
                            model.popView();
                          }),
                      ListTile(
                          leading:
                          Icon(Icons.edit_outlined, color: primaryColor),
                          title: Text('Edit'),
                          onTap: () {
                            model.popView();
                            model.editPost();
                          }),
                      ListTile(
                          leading:
                          Icon(Icons.share, color: primaryColor),
                          title: Text('Share to...'),
                          onTap: () {
                              model.sharePost();
                          }),
                      ListTile(
                          leading:
                          Icon(Icons.comment, color: primaryColor),
                          title: Text('Turn Off Commenting'),
                          onTap: () {

                          }),
                      ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: primaryColor,
                        ),
                        title: Text('Delete'),
                        onTap: () {
                          model.popView();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AppDialogBox(
                                    title: "Delete post",
                                    content:
                                    "Are you sure you want to delete this post?",
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            model.popView();
                                            model.deletePost();

                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: primaryColor),
                                          )),
                                      FlatButton(
                                          onPressed: () {
                                            model.popView();
                                          },
                                          child: Text("Cancel"))
                                    ]);
                              });
                        },
                      ),
                    ]:[
                      ListTile(
                          leading:
                          Icon(Icons.copy, color: primaryColor),
                          title: Text('Copy Link'),
                          onTap: () {
                            model.popView();
                            model.copyPostLink();
                          }),
                      ListTile(
                          leading:
                          Icon(Icons.share, color: primaryColor),
                          title: Text('Share to...'),
                          onTap: () {
                            model.popView();
                            model.sharePost();
                          })
                    ],
                  ),
                );
              });

        });
  }

}