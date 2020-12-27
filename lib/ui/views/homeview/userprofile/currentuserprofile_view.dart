import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/homeview/NavigationHandler.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:iati/ui/widgets/creation_aware_list_item.dart';
import 'package:iati/ui/widgets/removescrollglowview.dart';
import 'package:iati/ui/widgets/post_thumbnail/thumbnail_view.dart';
import 'currentuserprofile_viewmodel.dart';
import 'package:stacked/stacked.dart';


class CurrentUserProfileView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CurrentUserProfileViewModel>.reactive(
        initialiseSpecialViewModelsOnce: true,
        disposeViewModel: false,
        onModelReady: (model){
          model.listenToCurrentUserPosts();
        },
        builder: (context,model,child){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: NavigationHandler(child: Icon(Icons.arrow_back_ios,color: Colors.black,),),
          title: AutoSizeText(model.currentUser.userName!=null?model.currentUser.userName:""),centerTitle: true,actions: [IconButton(icon: Icon(Icons.more_horiz), onPressed: ()async{
          await model.logOut();
        })],),
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
                                          image: DecorationImage(image: model.currentUser.imageUrl!=null?CachedNetworkImageProvider(
                                            model.currentUser.imageUrl,
                                          ):AssetImage("assets/person.png"),fit: BoxFit.fill),
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                          border: Border.all(color: Colors.grey,width: 1)
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                  Center(child: AutoSizeText(model.currentUser.name!=null?model.currentUser.name:"Shinobi Ninja",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16],textAlign: TextAlign.center,)),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Center(child: AutoSizeText(model.currentUser.userName!=null?"@${model.currentUser.userName}":"@shinobininja",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),)),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                  AutoSizeText(model.currentUser.category!=null?model.currentUser.category:"Indie-Rock",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16],),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Center(child: AutoSizeText(model.currentUser.bio!=null?"@${model.currentUser.bio}":"We rock hard. It's what we do. Featured on Billboard,MTV & More...",style: TextStyle(color: Colors.black),)),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Divider(thickness: 2,),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Row(children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AutoSizeText(model.currentUser.followers!=null?model.currentUser.followers.length.toString():"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                          AutoSizeText("Followers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                        ],),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AutoSizeText(model.currentUser.following!=null?model.currentUser.following.length.toString():"0",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
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
                                          AutoSizeText(model.currentUser.subscriptions!=null?model.currentUser.subscriptions.length.toString():"0",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                          AutoSizeText("Subscriptions",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                        ],),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AutoSizeText(model.currentUser.subscribers!=null?model.currentUser.subscribers.length.toString():"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),presetFontSizes: [16],),
                                          AutoSizeText("Subscribers",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),presetFontSizes: [16],)
                                        ],),
                                    )
                                  ],),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Divider(thickness: 2,),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                  Row(children: [
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
                                        width: MediaQuery.of(context).size.width*0.4,
                                        child: Center(child: AutoSizeText("Insights & Privacy",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                      ),
                                    ))
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
                            if(index%20==0){
                              model.requestMoreCurrentUserData();
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
    }, viewModelBuilder: ()=>locator<CurrentUserProfileViewModel>());
  }

}