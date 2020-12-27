
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCategory extends StatelessWidget{
  final List<String> categories=["Soul","Hip-Hop","Alternative","News","Art","Drawing","Media","Entrepreneur","Painting","Series","Comedy","Podcast","Photography","Rock","Craft & DIY","Lifestyle","Fashion","Entertainment","Musician","Electronic","Blues","Jazz","Brand","R&B"];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Select Category",style: TextStyle(color: Colors.black),),),
      body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context,index){
        return ListTile(
          title: Text(categories[index]),
          onTap: (){
            Navigator.pop(context,categories[index]);
          },
        );
      }),
    ) ;
  }
}