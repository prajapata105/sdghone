import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ssda/app_theme.dart';
import 'package:ssda/route_generator.dart';
import 'package:ssda/services/cart_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appTHeme,
            initialRoute: '/home',
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
