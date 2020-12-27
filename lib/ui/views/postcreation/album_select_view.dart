import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stacked/stacked.dart';

class AlbumSelectView extends StatelessWidget {
  static Route route(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>AlbumSelectView(),
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
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
    return ViewModelBuilder<PostCreationViewModel>.reactive(
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        builder: (context,model,child){
      return Scaffold(
        body: ListView.builder(
            itemCount: model.allAlbums.length,
            itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              Navigator.pop(context,model.allAlbums[index].id);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(model.allAlbums[index].name),
          );
        }),
      );
    }, viewModelBuilder: ()=>locator<PostCreationViewModel>());
  }
}
