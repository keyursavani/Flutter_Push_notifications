import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_tutorial/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
  print(message.notification!.body.toString());
  print(message.data.toString());
  // eDet-G5ITMmjKijM-w0Pk7:APA91bF-G6u_9P8stVPedUuX6jSlfBeMM9lKDhz5LVmr49rW8zMJv1fyG4fhUdqMVnO4zoaYeDNbVQ3Oh2v9lL-iLj8pNLeBu_WxFY9qIBnKVSG_vB7EczGzT0dNExV14Gg9-kbzx4C-
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen(),
    );
  }
}

