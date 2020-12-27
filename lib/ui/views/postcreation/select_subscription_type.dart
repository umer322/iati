import 'package:flutter/material.dart';
import 'package:iati/models/subscription.dart';

class SelectSubscriptionType extends StatelessWidget {
  final List<Subscription> subscriptionTypes;
  SelectSubscriptionType({this.subscriptionTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Who can see this post?"),
        centerTitle: true,
      ),
      body: ListView.separated(
          separatorBuilder: (BuildContext context,int index){
            return Divider(thickness: 2,);
          },
          itemCount: subscriptionTypes.length,
          itemBuilder: (BuildContext context,int index){
        return ListTile(
          onTap: (){
            Navigator.pop(context,subscriptionTypes[index]);
          },
          title: Text(subscriptionTypes[index].title),
          subtitle: Text(subscriptionTypes[index].description),
        );
      }),
    );
  }
}
