import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iati/constant/app_colors.dart';

class AppProgressIndication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: primaryColor,
      size: 50.0,
    );
//      Platform.isAndroid?CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(primaryColor),):CupertinoActivityIndicator();
  }
}
