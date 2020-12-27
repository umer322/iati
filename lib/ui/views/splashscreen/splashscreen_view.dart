import 'package:flutter/material.dart';
import 'package:iati/ui/views/splashscreen/splashscreen_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashScreen extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>SplashScreen());
  }
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(builder: (BuildContext context,model,child){
      return Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png")
          ],),
      );
    }, viewModelBuilder: ()=>SplashViewModel(),
      onModelReady: (model){
        model.handleStartupLogic();
      },);
  }
}
