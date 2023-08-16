import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget{
  final String id;
  const MessageScreen({Key? key , required this.id}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageScreenState();
  }
}

class MessageScreenState extends State<MessageScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Meesage Screen" + widget.id),
      ),
      body: Container(),
    );
  }
}