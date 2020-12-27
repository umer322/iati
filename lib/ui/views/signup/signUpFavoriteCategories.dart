import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iati/constant/app_colors.dart';
import 'package:iati/locator.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class FavoriteCategories extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => FavoriteCategories());
  }

  @override
  _FavoriteCategoriesState createState() => _FavoriteCategoriesState();
}

class _FavoriteCategoriesState extends State<FavoriteCategories> {
  List<String> selectedCategories = [];
  List<String> categories=["Soul","Hip-Hop","Alternative","News","Art","Drawing","Media","Entrepreneur","Painting","Series","Comedy","Podcast","Photography","Rock","Craft & DIY","Lifestyle","Fashion","Entertainment","Musician","Electronic","Blues","Jazz","Brand","R&B"];
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.nonReactive(builder: (context,model,child){
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "I AM THE INDUSTRY",
            style: TextStyle(letterSpacing: 2),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.03),
              child: Row(
                children: [
                  Flexible(
                      child: AutoSizeText(
                        "Select three or more of your favorite categories.",
                        presetFontSizes: [20, 18, 16, 14],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
                  RaisedButton(
                    color: selectedCategories.length>2?primaryColor:Color(0xffEEEEEE),
                    onPressed: () {
                      if(selectedCategories.length<3){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Choose atleast three categories to continue")));
                      }
                      else{
                          model.goToUserSuggestions(selectedCategories);
                      }
                    },
                    child: Text("Next",style: TextStyle(color: selectedCategories.length>2?Colors.white:Colors.black,),),
                  )
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,),
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 2/1,crossAxisSpacing: 10,mainAxisSpacing: 10),itemCount: categories.length, itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  onTap: (){
                    if(selectedCategories.contains(categories[index])){
                      setState(() {
                        selectedCategories.remove(categories[index]);
                      });
                    }
                    else{
                      setState(() {
                        selectedCategories.add(categories[index]);
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: selectedCategories.contains(categories[index])?primaryColor:Colors.black45),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: AutoSizeText(categories[index],style: TextStyle(color: selectedCategories.contains(categories[index])?primaryColor:Colors.black45),),),),
                );
              }),
            ))
          ],
        ),
      );
    }, viewModelBuilder: ()=>locator<SignUpViewModel>());
  }
}
