import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:iati/locator.dart';
import 'package:iati/routes/route.dart';
import 'package:stacked_services/stacked_services.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value)async{
    await Firebase.initializeApp();
    setUpLocator();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: "IATI",
        theme: ThemeData(
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
