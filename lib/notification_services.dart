

import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_tutorial/mesage_screen.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async{
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized){
        print("User Granted Permission");
      }
      else if(settings.authorizationStatus == AuthorizationStatus.provisional){
        print("User Granted Provisional Permission");
      }
      else {
        print("User denied Permission");
      }
  }

  void initialLocalNotification(BuildContext context , RemoteMessage message) async{
    var androidInitializationSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSetting = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){
        handelMessage(context ,message);
      }
    );
  }


  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;
      if(kDebugMode){
        print("Notification Title :- ${notification!.title}");
        print("Notification Body :- ${notification.body}");
        print("Count :- ${androidNotification!.count}");
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      if(Platform.isAndroid){
        initialLocalNotification(context, message);
        showNotification(message);
      }
      if(Platform.isIOS){
        foregroundMessage();
      }
      else{
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
    Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'Your Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero,(){
    _flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title.toString(),
    message.notification!.body.toString(),
    notificationDetails);
    });
  }

  Future<String> getDeviceToken() async{
    String? token = await messaging.getToken();
    return token!;
  }

   isTokenRefresh() async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("Refresh Token");
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {

    // When App is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handelMessage(context, initialMessage);
    }
    // When App is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handelMessage(context, event);
    });
  }

  void handelMessage(BuildContext context , RemoteMessage message){
    if(message.data['type'] == 'msj'){
      Navigator.push(
        context,
      MaterialPageRoute(builder: (context){
        return MessageScreen(id:message.data['id'],);
      }));
    }
  }

  Future foregroundMessage() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}