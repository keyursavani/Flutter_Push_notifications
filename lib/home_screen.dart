import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_tutorial/notification_services.dart';

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
    notificationServices.firebaseInit();
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("Device Token");
      print(value);
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(),
    );
  }
 }