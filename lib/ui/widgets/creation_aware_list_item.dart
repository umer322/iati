import 'package:flutter/material.dart';

class CreationAwareListItem extends StatefulWidget {
  final Function itemCreated;
  final Widget child;
  CreationAwareListItem({Key key,this.child,this.itemCreated}):super(key: key);
  @override
  _CreationAwareListItemState createState() => _CreationAwareListItemState();
}

class _CreationAwareListItemState extends State<CreationAwareListItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.itemCreated!=null){
      widget.itemCreated();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
