import 'package:flutter/material.dart';
import 'package:iati/ui/views/homeview/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NavigationHandler extends ViewModelWidget<HomeViewModel>{
  final Widget child;
  NavigationHandler({Key key,this.child}):super(key: key,reactive: false);
  @override
  Widget build(BuildContext context,HomeViewModel viewModel) {
   return GestureDetector(
     onTap: (){
       viewModel.setIndex(0);
     },
     child: child,
   );
  }

}