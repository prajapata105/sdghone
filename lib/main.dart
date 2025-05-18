import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssda/route_generator.dart';
import 'package:ssda/screens/intro-screen/splasescreen.dart';

import 'app_theme.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}
void initNotification() async {
  // Android के लिए auto-permission, iOS के लिए explicit
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // FCM Token प्राप्त करें
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        )
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTHeme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}
