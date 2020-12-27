import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialogBox extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;
  AppDialogBox({this.title,this.actions,this.content});
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS?CupertinoAlertDialog(
      title: new Text(
          title),
      content: Text(content),
      actions: actions,
    ):AlertDialog(
      title: Text(
          title),
      content: Text(content),
      actions: actions,
    );
  }
}
