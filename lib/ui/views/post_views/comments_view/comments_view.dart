

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/user.dart';
import 'package:iati/ui/views/post_views/comments_view/comments_viewmodel.dart';
import 'package:iati/ui/views/post_views/comments_view/singlecomment_view.dart';
import 'package:iati/ui/widgets/app_progress_indicatior.dart';
import 'package:iati/ui/widgets/removescrollglowview.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CommentsView extends StatelessWidget{
  final Post post;
  final AppUser postUser;
  var _users = [
    {
      'id': '61as61fsa',
      'display': 'fayeedP',
      'full_name': 'Fayeed Pawaskar',
      'photo':
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
    {
      'id': '61asasgasgsag6a',
      'display': 'khaled',
      'full_name': 'DJ Khaled',
      'style': TextStyle(color: Colors.purple),
      'photo':
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
    {
      'id': 'asfgasga41',
      'display': 'markT',
      'full_name': 'Mark Twain',
      'photo':
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
    {
      'id': 'asfsaf451a',
      'display': '@~|[]{}#%^*+=|\$<>£€•.,?!',
      'full_name': 'Jhon Legend',
      'photo':
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
  ];
  CommentsView({this.postUser,this.post});
  final GlobalKey<FlutterMentionsState> _key = GlobalKey<FlutterMentionsState>();
  static Route route(Post post,AppUser user){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>CommentsView(postUser: user,post: post,),
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },);
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentsViewModel>.reactive(
        onModelReady: (model){
          model.listenToComments(post, postUser);
        },
        builder: (context,model,child){
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: (){
                model.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,),
          ),
          title: Text("Comments",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
        ),
        body: model.isBusy?Center(child: AppProgressIndication(),):Column(
          children: [
            Expanded(child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: CustomScrollView(
                slivers: [
                  model.currentPost.caption!=null?SliverToBoxAdapter(
                    child: model.currentPost.caption.isEmpty?SizedBox():Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.03),vertical: getWidth(context, 0.03)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.05)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: AutoSizeText.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                        text: model.postUser.userName==null?"No UserName  ":model.postUser.userName+"  ",
                                        style: TextStyle(color: blueColor,fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()..onTap=(){
                                          model.goToUserProfile(model.postUser.id);
                                        }
                                      ),
                                      TextSpan(
                                        text: model.hasLongCaption?model.longCaption?model.currentPost.caption.substring(0,90):model.currentPost.caption:model.currentPost.caption,
                                        style: TextStyle(color: Colors.grey)
                                      ),
                                      model.hasLongCaption?TextSpan(
                                        text: !model.longCaption?"..less":"... more",
                                          style: TextStyle(color: Colors.grey),
                                          recognizer: TapGestureRecognizer()..onTap=()=>model.toggleCaption()
                                      ):TextSpan()
                                    ]
                                  ))),
                                  SizedBox(height: 5,),
                                  AutoSizeText(DateFormat.yMMMd().format(model.currentPost.time))
                                ],
                              ),
                            ),
                          )
                        ],),
                      ),
                    ),
                  ):SliverToBoxAdapter(child: SizedBox(),),
                  model.comments==null?SliverToBoxAdapter(child: AppProgressIndication(),):
                  SliverToBoxAdapter(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount:model.comments.length,
                        //shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //padding: EdgeInsets.all(0),
                        separatorBuilder: (BuildContext context, int index){
                          return Divider(thickness: 2,);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return SingleCommentView(key: Key(model.comments[index].id),comment: model.comments[index],);
                        }),
                  )
                ],
              ),
            )),
            Divider(thickness: 2,),
            ListTile(
              trailing: GestureDetector(
                onTap: model.writingComment?(){
                  model.addComment(_key.currentState.controller.markupText);
                  _key.currentState.controller.clear();
                }:null,
                child: Text(
                  "SEND",
                  style: TextStyle(color: model.writingComment?blueColor:Colors.grey,fontWeight: FontWeight.w500),
                ),
              ),
              title: FlutterMentions(
                key: _key,
                suggestionPosition: SuggestionPosition.Top,
                autocorrect: false,
                onMarkupChanged: (val) {
                  model.changeCommentState(val);
                  print("here $val");
                },
                onSuggestionVisibleChanged: (val) {
//              setState(() {
//                _showList = val;
//              });
                },
                onSearchChanged: (
                    trigger,
                    value,
                    ) {
                  print('again | $trigger | $value ');
                },
                onMentionAdd: (data){
                  print(data);
                },
                hideSuggestionList: false,
                onEditingComplete: () {
                  _key.currentState.controller.clear();
                  // key.currentState.controller.text = '';
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                  hintText: "Write Something..."
                ),
                mentions: [
                  Mention(
                      trigger: r'@',
                      data: _users,
                      style: TextStyle(
                        color: blueColor,
                      ),
                      matchAll: false,
                      suggestionBuilder: (data) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  data['photo'],
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(data['full_name']),
                                  Text('@${data['display']}'),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                  Mention(
                      trigger: r'#',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      matchAll: false,
                      suggestionBuilder: (data) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
//                            CircleAvatar(
//                              backgroundImage: NetworkImage(
//                                data['photo'],
//                              ),
//                            ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(data['full_name']),
                                  Text('@${data['display']}'),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      );
    }, viewModelBuilder: ()=>CommentsViewModel());
  }

}