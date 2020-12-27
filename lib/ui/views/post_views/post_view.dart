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
import 'package:iati/ui/views/post_views/post_viewmodel.dart';
import 'package:iati/ui/views/postcreation/videoposts/networkvideo_view.dart';
import 'package:iati/ui/widgets/app_dialog_box.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:stacked/stacked.dart';

class PostView extends StatelessWidget {
  final Post post;
  PostView({this.post});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        onModelReady: (model) {
          model.listenToData(postId: post.id, userID: post.userId);
        },
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Posts"),
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        Platform.isIOS
                              ? showCupertinoModalPopup(
                              context: context,
                              builder: (_) {
                                return CupertinoActionSheet(
                                  actions: [
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
                                        'Delete',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                      onPressed: () {
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
                                                          model.popView();
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
                                  ],
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
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: new Wrap(
                                    children: <Widget>[
                                      new ListTile(
                                          leading:
                                          new Icon(Icons.edit_outlined, color: primaryColor),
                                          title: new Text('Edit'),
                                          onTap: () {
                                            model.popView();
                                            model.editPost();
                                          }),
                                      new ListTile(
                                        leading: new Icon(
                                          Icons.delete_outline,
                                          color: primaryColor,
                                        ),
                                        title: new Text('Delete'),
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
                                                            model.popView();
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
                                    ],
                                  ),
                                );
                              });

                      })
                ],
              ),
              body: model.isBusy
                  ? Center(
                      child: AppProgressIndication(),
                    )
                  : ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(context, 0.05),
                              vertical: getWidth(context, 0.03)),
                          child: Row(
                            children: [
                              Container(
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
                              SizedBox(
                                width: 5,
                              ),
                              Column(
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
                              Spacer(),
                              Container(
                                  height: getWidth(context, 0.08),
                                  width: getWidth(context, 0.08),
                                  child: Image.asset("assets/icons/star.png"))
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
                          child: model.currentPost.fileUrls[0].isVideo?NetworkVideoView(data: model.currentPost.fileUrls[0].file,):CachedNetworkImage(
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
                                        isLiked: model.currentPost.likes
                                                .contains(model.currentPost.id)
                                            ? true
                                            : false,
                                      ),
                                      SizedBox(
                                        width: getWidth(context, 0.05),
                                      ),
                                      Container(
                                          height: getHeigth(context, 0.04),
                                          width: getHeigth(context, 0.04),
                                          child: SvgPicture.asset(
                                            "assets/icons/Comment.svg",
                                            color: Colors.grey,
                                          )),
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
                                  AutoSizeText(
                                    "View all ${0} comments",
                                    presetFontSizes: [16, 14],
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ));

        },
        viewModelBuilder: () => PostViewModel());
  }
}
