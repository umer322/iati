import 'package:flutter/cupertino.dart';

 double getHeigth(BuildContext context,double heigth){
    return MediaQuery.of(context).size.height*heigth;
  }
  double getWidth(BuildContext context,double width){
    return MediaQuery.of(context).size.width*width;
 }
