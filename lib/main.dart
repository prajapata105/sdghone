import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/app_theme.dart';
import 'package:ssda/controller/AddressController.dart';
import 'package:ssda/controller/OrderDetailsController.dart';
import 'package:ssda/controller/UserOrdersController.dart';
import 'package:ssda/route_generator.dart';
import 'package:ssda/services/OrderService.dart';
import 'package:ssda/services/cart_service.dart';

// <<<--- इन दो फाइलों को इम्पोर्ट करें ---<<<
import 'controller/network_controller.dart';
import 'ui/widgets/common/no_internet_widget.dart'; // आपकी नो-इंटरनेट UI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // सभी स्थाई कंट्रोलर्स और सर्विसेज को यहाँ डालें
  Get.put(CartService(), permanent: true);
  Get.put(AddressController(), permanent: true);
  Get.put(OrderService(), permanent: true);
  Get.put(UserOrdersController(), permanent: true);
  Get.put(OrderDetailsController(), permanent: true);
  // Get.put(UserOrdersController(), permanent: true); // यह लाइन दो बार थी, एक हटा दी
  Get.put(NetworkController(), permanent: true);
  runApp(const MyApp());
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTHeme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,

      // <<<--- ग्लोबल 'नो इंटरनेट' पेज का लॉजिक यहाँ से शुरू ---<<<
      builder: (context, child) {
        // Obx विजेट इंटरनेट की स्थिति पर लगातार नजर रखेगा
        return Obx(() {
          // नेटवर्क कंट्रोलर को एक्सेस करें
          final networkController = Get.find<NetworkController>();

          return Stack(
            children: [
              // 'child!' का मतलब है आपकी ऐप की वर्तमान स्क्रीन जो AppRouter से आ रही है
              child!,

              // अगर इंटरनेट कनेक्टेड नहीं है, तो NoInternetWidget को पूरी स्क्रीन पर दिखाएं
              if (!networkController.isConnected)
                const NoInternetWidget(),
            ],
          );
        });
      },
      // <<<--- लॉजिक यहाँ खत्म ---<<<
    );
  }
}