

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/models/post.dart';
import 'package:iati/models/subscription.dart';
import 'package:iati/ui/views/postcreation/caption_view.dart';
import 'package:iati/ui/views/postcreation/select_subscription_type.dart';
import 'package:iati/ui/widgets/removescrollglowview.dart';
import 'package:stacked/stacked.dart';

import 'postedit_viewmodel.dart';

class PostEditView extends StatefulWidget {
  final Post post;
  PostEditView(this.post);

  @override
  _PostEditViewState createState() => _PostEditViewState();
}

class _PostEditViewState extends State<PostEditView> {
  final titleController=TextEditingController();
  String title;
  GlobalKey<FlutterMentionsState> captionKey;
  final _formKey=GlobalKey<FormState>();
  Subscription subscriptionType= Subscription(
      title: "Public",
      description: "Visible to everyone",
      limited: false
  );
  @override
  void initState() {
    // TODO: implement initState
    captionKey = GlobalKey<FlutterMentionsState>();
    super.initState();
    if(widget.post!=null){
      subscriptionType=widget.post.subscriptionType;
      titleController.text=widget.post.title;
    }
  }
  @override
  Widget build(BuildContext context){
    return ViewModelBuilder<PostEditViewModel>.reactive(
       onModelReady: (model){
         print(widget.post.id);
         model.setPost(widget.post);
       },
        builder: (context,model,child){
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(title: Text("Edit Post"),centerTitle: true,automaticallyImplyLeading: true,),
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
                            child: CachedNetworkImage(imageUrl:model.currentPost.coverImage,fit: BoxFit.fill,)),
                      ),
                    ),
                    SizedBox(height: 10,),
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
                                defaultText: widget.post.caption,
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
                    GestureDetector(
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
                          onTap: (){
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              model.currentPost.title=title;
                              model.currentPost.caption=captionKey.currentState.controller.text;
                              model.currentPost.subscriptionType=subscriptionType;
                              model.editPostAndGoBack();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color:lightPrimaryColor
                            ),
                            height: MediaQuery.of(context).size.height*0.045,
                            width: MediaQuery.of(context).size.width*0.4,
                            child: Center(child: AutoSizeText("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),presetFontSizes: [16,14],),),
                          ),
                        ),
                      ],)
                  ],
                ),
              ),
            ),
          );
        }, viewModelBuilder: ()=>PostEditViewModel());
  }
}


