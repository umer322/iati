import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:iati/constant/Responsive.dart';
import 'package:iati/constant/app_colors.dart';

class CaptionView extends StatefulWidget {
  final String caption;
  CaptionView({this.caption});

  @override
  _CaptionViewState createState() => _CaptionViewState();
}

class _CaptionViewState extends State<CaptionView> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  bool _showList = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Caption"),centerTitle: true,
      actions: [
        FlatButton(onPressed: (){

          Navigator.pop(context,key.currentState.controller.text);
        }, child: Text("Save",style: TextStyle(color: Colors.black,fontSize: 16),))
      ],),
      body: Column(
        children: [
          Expanded(child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(context, 0.05)),
            child: FlutterMentions(
              key: key,
              defaultText: widget.caption??"",
              maxLength: 2200,
              expands: true,
              maxLines: null,
              suggestionPosition: SuggestionPosition.Bottom,
              autocorrect: false,
              onMarkupChanged: (val) {
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
                key.currentState.controller.clear();
                // key.currentState.controller.text = '';
              },
              decoration: InputDecoration(
                  border: InputBorder.none
              ),
              autofocus: true,
              mentions: [
                Mention(
                    trigger: r'@',
                    style: TextStyle(
                      color: blueColor,
                    ),
                    matchAll: false,
                    data: _users,
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
                    data: _users,
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
          ),),
          Expanded(child: SizedBox())
        ],
      ),
    );
  }
}

