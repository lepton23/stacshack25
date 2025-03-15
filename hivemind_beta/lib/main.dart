import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hivemind_beta/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hivemind_beta/views/screens/firebase_test.dart';
// import 'locator.dart';

 Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message}");
 } 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false, 
    criticalAlert: false,
    provisional: false,
    sound: true
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BMODN9xVEPIcUOblSSaauM6JOPtso9pQdZltFZnOIz7eA5w6tICs6Q8GbhqO8VC22a0vddXC8_UN07aOWsxpwPQ");
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) => { }).onError((err) => { });
  // String? token = await FirebaseMessaging.instance.getToken();
  print('User Granted Permission ${settings.authorizationStatus}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: FirebaseTest()
    );
  }
}
