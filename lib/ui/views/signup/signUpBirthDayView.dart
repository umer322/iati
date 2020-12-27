import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class SignUpBirthDayView extends StatefulWidget {
  static Route route(){
    return MaterialPageRoute(builder: (_)=>SignUpBirthDayView());
  }
  @override
  _SignUpBirthDayViewState createState() => _SignUpBirthDayViewState();
}

class _SignUpBirthDayViewState extends State<SignUpBirthDayView> {
  DateTime selectedDate;
  bool error=false;
  final textController=TextEditingController();

  _buildIOsDatePicker(BuildContext context) async{
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate && picked.isBefore(DateTime.now()))
                  setState(() {
                    selectedDate = picked;
                    textController.text=DateFormat.yMMMd().format(selectedDate);
                  });
              },
              initialDateTime: DateTime.now().subtract(Duration(days: 4745)),
              minimumYear: 1950,
              maximumYear: DateTime.now().subtract(Duration(days: 4745)).year,
            ),
          );
        });
  }
  _buildAndroidDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 4745)), // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(Duration(days: 4745)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        textController.text=DateFormat.yMMMd().format(selectedDate);
      });
  }

  _selectDate(BuildContext context)async{
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
        return _buildAndroidDatePicker(context);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.iOS:
        return _buildIOsDatePicker(context);
      case TargetPlatform.macOS:
        return _buildAndroidDatePicker(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.nonReactive(builder: (context,model,child){
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true,title: Text("Sign Up",)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07,vertical: MediaQuery.of(context).size.height*0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText("When's your birthday?",presetFontSizes: [22,21,20,19,18,16],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),maxLines: 1,),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              AutoSizeText("Your birthday won't be shown publicly",style: TextStyle(color: Colors.black38,height: 1.5),presetFontSizes: [16,14,12],maxLines: 2,),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              TextField(
                controller: textController,
                keyboardType: TextInputType.emailAddress,
                onTap: () => _selectDate(context),
                readOnly: true,
                decoration: InputDecoration(
                  errorText: error?"Please select your birthday":null,
                  hintText: "Birthday",
                  hintStyle: TextStyle(color: Colors.black26),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              GestureDetector(
                onTap: (){
                  if(selectedDate==null){
                    setState(() {
                      error=true;
                    });
                  }else{
                    model.goToFavoritesCategory(selectedDate);
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primaryColor
                  ),
                  child: Center(child: AutoSizeText("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),presetFontSizes: [18,16,14],),),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}