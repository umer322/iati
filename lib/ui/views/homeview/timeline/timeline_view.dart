import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/ui/views/homeview/timeline/timeline_viewmodel.dart';
import 'package:iati/ui/views/homeview/timeline/timelineposts_view.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:iati/ui/widgets/creation_aware_list_item.dart';
import 'package:stacked/stacked.dart';

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TimeLineViewModel>.reactive(
        onModelReady: (model){
          model.listenToTimeLinePosts();
        },
        builder: (context,model,child){
      return Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.all(15),
            child: SvgPicture.asset(
              "assets/icons/inbox.svg",
              height: getHeigth(context, 0.02),
              width: getHeigth(context, 0.02),
              color: Colors.black,
            ),
          ),
          title: Image.asset("assets/name.png"),
          actions: [
            Container(
              padding: EdgeInsets.all(15),
              child: SvgPicture.asset(
                "assets/icons/Notification - Grey.svg",
                height: getHeigth(context, 0.02),
                width: getHeigth(context, 0.02),
                color: Colors.grey,
              ),
            ),
          ],
        ),
        body: model.currentUser.following.length==0?
          SafeArea(
            child: model.isBusy?Center(child: AppProgressIndication(),):RefreshIndicator(
              onRefresh: ()async{
                await model.refreshView();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.15),vertical: getHeigth(context, 0.05)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText("Welcome to IATI",style: TextStyle(color: Colors.black,fontSize: 26),),
                        SizedBox(height: 10,),
                        AutoSizeText("Follow people to start seeing the photos and videos they share",textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context,index){
                        return CreationAwareListItem(
                          itemCreated: (){
                            if((index+1)%10==0 && index !=0){
                              model.requestMoreData();
                            }
                          },
                          child: model.suggestedUsers[index].followers.contains(model.currentUser.id)?SizedBox(height: 1,):
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: getWidth(context, 0.08),vertical: getWidth(context,0.025)),
                            child: Row(children: [
                              Container(
                                height: getWidth(context, 0.13),
                                width: getWidth(context, 0.13),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        image:  model.suggestedUsers[index].imageUrl!=null?CachedNetworkImageProvider(
                                            model.suggestedUsers[index].imageUrl
                                        ):AssetImage("assets/person.png")
                                    )
                                ),
                              ),
                              SizedBox(width: getWidth(context, 0.05),),
                              Expanded(child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(model.suggestedUsers[index].name==null?"No Name":model.suggestedUsers[index].name,style: TextStyle(color: Colors.black),presetFontSizes: [16],),
                                  SizedBox(height: 5,),
                                  AutoSizeText(model.suggestedUsers[index].userName==null?"No username":model.suggestedUsers[index].userName,style: TextStyle(color: Colors.grey),)
                                ],
                              )),
                              InkWell(
                                onTap: (){
                                  model.followUser(model.suggestedUsers[index].id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:blueColor
                                  ),
                                  height: MediaQuery.of(context).size.height*0.04,
                                  width: MediaQuery.of(context).size.width*0.2,
                                  child: Center(child: AutoSizeText("Follow",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14,12],),),
                                ),
                              )
                            ],),
                          ),
                        );
                      },
                      childCount: model.suggestedUsers.length,
                    ),
                  )
                ],
              ),
            ),
          ):TimeLinePostsView(),
      );
    }, viewModelBuilder: ()=>TimeLineViewModel());
  }
}
