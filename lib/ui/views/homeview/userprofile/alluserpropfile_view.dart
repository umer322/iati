import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/homeview/NavigationHandler.dart';
import 'package:iati/ui/views/homeview/userprofile/alluserprofile_viewmodel.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:iati/ui/widgets/creation_aware_list_item.dart';
import 'package:iati/ui/widgets/removescrollglowview.dart';
import 'package:iati/ui/widgets/post_thumbnail/thumbnail_view.dart';
import 'package:stacked/stacked.dart';


class UserProfileView extends StatelessWidget{
  static Route route(String userId){
    return MaterialPageRoute(builder: (_)=>UserProfileView(userId: userId,));
  }
  final String userId;
  UserProfileView({this.userId});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
        onModelReady: (model){
          WidgetsBinding.instance.addPostFrameCallback((_){
            model.listenToUserProfileData(userId);
          });
        },
        builder: (context,model,child){
          return model.isBusy?Material(child: Center(child: AppProgressIndication(),),):model.profileUser==null?Material(child: SizedBox(),):Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: AutoSizeText(model.profileUser.userName!=null?model.profileUser.userName:""),centerTitle: true,
                actions: [Container(
                    height: getWidth(context, 0.08),
                    width: getWidth(context, 0.08),
                    child: ProfileOptions())],),
              body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                                Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.15,
                                    width:  MediaQuery.of(context).size.height*0.15,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(image: model.profileUser.imageUrl!=null?CachedNetworkImageProvider(
                                          model.profileUser.imageUrl,
                                        ):AssetImage("assets/person.png"),fit: BoxFit.fill),
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                        border: Border.all(color: Colors.grey,width: 1)
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                Center(child: AutoSizeText(model.profileUser.name!=null?model.profileUser.name:"Shinobi Ninja",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16],textAlign: TextAlign.center,)),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Center(child: AutoSizeText(model.profileUser.userName!=null?"@${model.profileUser.userName}":"@shinobininja",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),)),
                                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                AutoSizeText(model.profileUser.category!=null?model.profileUser.category:"Indie-Rock",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16],),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Center(child: AutoSizeText(model.profileUser.bio!=null?"@${model.profileUser.bio}":"We rock hard. It's what we do. Featured on Billboard,MTV & More...",style: TextStyle(color: Colors.black),)),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Divider(thickness: 2,),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Row(children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(model.profileUser.followers!=null?model.profileUser.followers.length.toString():"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                        AutoSizeText("Followers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                      ],),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(model.profileUser.following!=null?model.profileUser.following.length.toString():"0",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                        AutoSizeText("Following",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                      ],),
                                  )
                                ],),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Row(children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(model.profileUser.subscriptions!=null?model.profileUser.subscriptions.length.toString():"0",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                        AutoSizeText("Subscriptions",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                      ],),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(model.profileUser.subscribers!=null?model.profileUser.subscribers.length.toString():"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                        AutoSizeText("Subscribers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                      ],),
                                  )
                                ],),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Divider(thickness: 2,),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                               model.isCurrentUser?Row(children: [
                                  Expanded(child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white
                                      ),
                                      height: MediaQuery.of(context).size.height*0.04,
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child: Center(child: AutoSizeText("Edit Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                    ),
                                  )),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    width: 1,height: MediaQuery.of(context).size.height*0.04,decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(25)),),
                                  Expanded(child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.white
                                      ),
                                      height: MediaQuery.of(context).size.height*0.04,
                                      child: Center(child: AutoSizeText("Insights & Privacy",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                    ),
                                  ))
                                ],):
                                Row(children: [
                                  Expanded(
                                      flex:2,
                                      child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:Border.all(color: model.isFollowing?Colors.grey:Colors.white),
                                          borderRadius: BorderRadius.circular(50),
                                          color: model.isFollowing?Colors.white:blueColor
                                      ),
                                      height: MediaQuery.of(context).size.height*0.04,
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child: Center(child: AutoSizeText(model.isFollowing?"Following":"Follow",style: TextStyle(color: model.isFollowing?Colors.black:Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                    ),
                                  )),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width: 1,height: MediaQuery.of(context).size.height*0.04,decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(25)),),
                                  Expanded(
                                      flex:2,
                                      child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: yellowColor
                                      ),
                                      height: MediaQuery.of(context).size.height*0.04,
                                      child: Center(child: AutoSizeText("Subscribe",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                    ),
                                  )),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width: 1,height: MediaQuery.of(context).size.height*0.04,decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(25)),),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Container(
                                        padding:EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/icons/inbox.svg",
                                          height: getHeigth(context, 0.02),
                                          width: getHeigth(context, 0.02),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Divider(thickness: 2,),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                              ],),
                          );
                        },childCount: 1)),
                    model.userPosts==null?SliverToBoxAdapter(child: Center(child: AppProgressIndication(),),):SliverGrid(delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                      return CreationAwareListItem(
                        itemCreated: (){
                          if(model.userPosts[index].fileUrls.length==0){
                            model.deletePost(model.userPosts[index].id);
                          }
                          if(index%20==0 && index !=0){
                            model.requestMoreUserData();
                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width*0.3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:model.userPosts[index].fileUrls.length==0?Center(child: Icon(Icons.error),):ThumbnailView(post:model.userPosts[index])
                        ),
                      );},
                        childCount: model.userPosts.length), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 8,mainAxisSpacing: 8))
                  ],
                ),
              )
          );
        }, viewModelBuilder: ()=>UserProfileViewModel());
  }

}


class ProfileOptions extends ViewModelWidget<UserProfileViewModel> {
  @override
  Widget build(BuildContext context, UserProfileViewModel model) {
    return IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: () {
          Platform.isIOS
              ? showCupertinoModalPopup(
              context: context,
              builder: (_) {
                return CupertinoActionSheet(
                  actions: model.profileUser.id != model.currentUser.id ? [
                    CupertinoActionSheetAction(
                      child: Text(
                        'Subscribe',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Send Message',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Share Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                          model.popView();
                          model.shareProfile();
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Turn off Post Notifications',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        'Block', style: TextStyle(color: Colors.red),

                      ),
                      onPressed: () {

                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                          'Report',
                          style: TextStyle(color: Colors.red)
                      ),
                      onPressed: () {

                      },
                    ),
                  ] : [],
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Wrap(
                    children: model.profileUser.id != model.currentUser.id ? [
                      ListTile(
                          leading:
                          Icon(Icons.copy, color: primaryColor),
                          title: Text('Subscribe'),
                          onTap: () {

                          }),
                      ListTile(
                          leading:
                          Icon(Icons.edit_outlined, color: primaryColor),
                          title: Text('Send Message'),
                          onTap: () {

                          }),
                      ListTile(
                          leading:
                          Icon(Icons.share, color: primaryColor),
                          title: Text('Share Profile'),
                          onTap: () {
                            model.popView();
                            model.shareProfile();
                          }),
                      ListTile(
                          leading:
                          Icon(Icons.comment, color: primaryColor),
                          title: Text('Turn off Post Notification'),
                          onTap: () {

                          }),
                      ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: primaryColor,
                        ),
                        title: Text(
                          'Block', style: TextStyle(color: Colors.red),),
                        onTap: () {

                        },
                      ),
                      ListTile(
                          leading:
                          Icon(Icons.copy, color: primaryColor),
                          title: Text(
                              'Report', style: TextStyle(color: Colors.red)),
                          onTap: () {

                          }),
                    ] : [],
                  ),
                );
              });
        });
  }
}