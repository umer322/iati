import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iati/ui/views/homeview/home_viewmodel.dart';
import 'package:iati/ui/views/homeview/timeline/timeline_view.dart';
import 'package:iati/ui/views/homeview/userprofile/currentuserprofile_view.dart';
import 'package:stacked/stacked.dart';


class HomeView extends StatelessWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>HomeView(),settings: RouteSettings(name: "HomePage"));
  }
  final List<Map> pages=[{
    "body":TimeLine(),
    "selected":"assets/icons/Home - Black.svg",
    "not_selected":"assets/icons/Home - Grey.svg",
    "type":"icon"
  },{
    "body":Container(),
    "selected":"assets/icons/Search - Black.svg",
    "not_selected":"assets/icons/Search - Grey.svg",
    "type":"icon"
  },{
    "body":Container(),
    "selected":"assets/icons/plus.svg",
    "not_selected":"assets/icons/plus.svg",
    "type":"icon"
  },{
    "body":Container(),
    "selected":"assets/icons/Subscription - Black.svg",
    "not_selected":"assets/icons/Subscription.svg",
    "type":"icon"
  },{
    "body":CurrentUserProfileView(),
    "icon":
//    Consumer<UserServices>(builder: (BuildContext context,model,_){
//      return Center(
//        child: Container(height: MediaQuery.of(context).size.height*0.06,width: MediaQuery.of(context).size.height*0.06,
//          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),
//          child: model.user.imageUrl!=null?ClipRRect(
//              borderRadius: BorderRadius.circular(25),
//              child: CachedNetworkImage(imageUrl: model.user.imageUrl,fit: BoxFit.fill,)):
          Image.asset("assets/person.png",),
//) ),
//      );
//    })
  }];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(builder: (context,model,child){
      return Scaffold(
        body: Column(children: [
          Expanded(child: pages[model.currentIndex]['body']),
          Row(children: [
            icons(context,model, 0),
            icons(context,model, 1),
            icons(context,model, 2),
            icons(context,model, 3),
            icons(context,model, 4),
//                ],)
        ],
        ),]));
    }, viewModelBuilder: ()=>HomeViewModel());
  }
  icons(BuildContext context,HomeViewModel model, int index) {
    return Expanded(
        child:GestureDetector(
          onTap: (){
            if(index==2){
              model.goToPostCreationPage();
            }
            else{
              model.setIndex(index);
            }
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: model.currentIndex==index?Colors.black:Colors.grey,width: 2))
            ),
            height: MediaQuery.of(context).size.height*0.07,
            duration: Duration(milliseconds: 300),child: pages[index]['type']=="icon"?Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width*0.035),
            child: SvgPicture.asset(model.currentIndex==index?pages[index]['selected']:pages[index]['not_selected'],color: model.currentIndex==index?Colors.black:Colors.grey),
          ):pages[index]['icon'],),
        )
    );
  }
}
