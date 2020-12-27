import 'package:flutter/material.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignUpTemplateView extends StatelessWidget {
  final Widget page;
  SignUpTemplateView({this.page});
  static Route route(page){
    return MaterialPageRoute(builder: (_)=>SignUpTemplateView(page: page,));
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.nonReactive(
        disposeViewModel: false,
        builder: (context,model,child){
      return page;
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}
