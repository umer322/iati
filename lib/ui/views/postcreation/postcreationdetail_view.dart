import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/subscription.dart';
import 'package:iati/ui/views/postcreation/select_category.dart';
import 'package:iati/ui/widgets/removescrollglowview.dart';
import 'package:stacked/stacked.dart';

import 'caption_view.dart';
import 'postcreation_viewmodel.dart';
import 'select_subscription_type.dart';

class DetailPostCreationView extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>DetailPostCreationView());
  }
  @override
  _DetailPostCreationViewState createState() => _DetailPostCreationViewState();
}

class _DetailPostCreationViewState extends State<DetailPostCreationView> {
  final titleController=TextEditingController();
  String title;
  GlobalKey<FlutterMentionsState> captionKey = GlobalKey<FlutterMentionsState>();
  final _formKey=GlobalKey<FormState>();
  Subscription subscriptionType= Subscription(
      title: "Public",
      description: "Visible to everyone",
      limited: false
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return ViewModelBuilder<PostCreationViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        builder: (context,model,child){
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text("New Post"),centerTitle: true,automaticallyImplyLeading: true,),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical:MediaQuery.of(context).size.width*0.03),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    height: MediaQuery.of(context).size.width*0.3,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.memory(model.selectedPost.localCoverImage,filterQuality: FilterQuality.high,fit: BoxFit.cover,)),
                  ),
                ),
                SizedBox(height: 10,),
                model.selectedPost.fileUrls[0].isVideo?Container(width:MediaQuery.of(context).size.width,child: GestureDetector(
                    onTap: ()async{
                        model.getListOfImages(model.selectedPost.fileUrls[0].file);
                        model.goToVideoThumbnailsView();
                    },
                    child: AutoSizeText("Select Cover",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,presetFontSizes: [16,14],))):SizedBox(),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                TextFormField(
                  autocorrect: false,
                  validator: (val){
                    if(val.isEmpty){
                      return "Title is required";
                    }
                    return null;
                  },
                  onSaved: (val){
                    title=val;
                  },
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Post Title"),
                  maxLength: 100,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: ()async{
                      print("coming here");
                      String data=await Navigator.push(context,MaterialPageRoute(builder: (_)=>CaptionView(caption: captionKey.currentState.controller.text,)));
                      if(data!=null){
                        setState(() {
                          captionKey.currentState.controller.text=data;
                        });
                      }
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.15),
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: FlutterMentions(
                            key: captionKey,
                            mentions: [
                              Mention(
                                  trigger: r'@',
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
                            enabled: false,
                            maxLines: null,
                            decoration: InputDecoration(labelText: "Caption",
                                labelStyle: TextStyle(color: primaryColor)
                            ),
                          ),
                        ),
                      ),
                    )

                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
//                GestureDetector(
//                  onTap: ()async{
//                    var data=await Navigator.push(context, MaterialPageRoute(builder: (_)=>SelectCategory()));
//                    if(data!=null){
//                      setState(() {
//                        model.selectedPost.category=data;
//                      });
//                    }
//                  },
//                  child: Row(children: [
//                    AutoSizeText("Category",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16,14],),
//                    Spacer(),
//                    AutoSizeText(model.selectedPost.category!=null?model.selectedPost.category:"",presetFontSizes: [16,14],),Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,)
//                  ],),
//                ),
//                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: ()async{
                  var data=await Navigator.push(context, MaterialPageRoute(builder: (_)=>SelectSubscriptionType(subscriptionTypes: model.currentUser.subscriptionTypes,)));
                  print(data);
                  if(data!=null){
                    setState(() {
                      subscriptionType=data;
                    });
                  }
                  },
                  child: Row(children: [
                    AutoSizeText("Privacy",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),presetFontSizes: [18,16,14],),
                    Spacer(),
                    AutoSizeText(subscriptionType?.title??"",presetFontSizes: [16,14],),Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,)
                  ],),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();
                          model.selectedPost.title=title;
                          model.selectedPost.caption=captionKey.currentState.controller.text;
                          model.selectedPost.subscriptionType=subscriptionType;
                          model.uploadPost();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:lightPrimaryColor
                        ),
                        height: MediaQuery.of(context).size.height*0.045,
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Center(child: AutoSizeText("Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14],),),
                      ),
                    ),
                  ],)
              ],
            ),
          ),
        ),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }
}


