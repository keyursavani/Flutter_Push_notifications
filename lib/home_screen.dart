import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_tutorial/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}
 class HomeScreenState extends State<HomeScreen>{
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
     if(kDebugMode){
       print("Device Token");
       print(value);
     }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: TextButton(
          onPressed: (){
            notificationServices.getDeviceToken().then((value) async{
              var data = {
                'to': value.toString(),
                'priority':'high',
                'notification':{
                  'title' : 'Title',
                  'body': 'Body'
                },
                'data':{
                  'type':'msj',
                  'id':'123456'
                },
              };
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
                headers: {
                  'Content-Type' :'application/json; charset=UTF-8',
                  'Authorization' : 'key=AAAAJpSawxU:APA91bEgd7WkzJCmxCNBlVWrlUEV1LOvoHB0sG-WbCgQk9yXnB6ofpN9eHmkV_xlMxKOBkSlaWDXTQEWQ3Zdx8361Kfc3fcJsd7tTQhHcIAGw_wI27doeY4jonK2wZDUp7spA9C8HVTe'
                }
              );
            });
          },
          child:Text("Send Message"),
        ),
      ),
    );
  }
 }