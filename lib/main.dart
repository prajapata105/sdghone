import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/Services/Providers/custom_auth_provider.dart';
import 'package:ssda/app_theme.dart';
import 'package:ssda/controller/AddressController.dart';
import 'package:ssda/controller/HomeController.dart';
import 'package:ssda/controller/OrderDetailsController.dart';
import 'package:ssda/controller/UserOrdersController.dart';
import 'package:ssda/controller/network_controller.dart';
import 'package:ssda/route_generator.dart';
import 'package:ssda/services/OrderService.dart';
import 'package:ssda/services/cart_service.dart';
import 'package:ssda/services/notification_service.dart';
import 'package:ssda/ui/widgets/common/no_internet_widget.dart';

// यह टॉप-लेवल फंक्शन किसी भी क्लास के बाहर होना चाहिए
// ताकि यह तब भी काम करे जब ऐप बंद हो।
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ [BACKGROUND HANDLER] Background message received: ${message.messageId}");
}

/// ऐप की सभी सर्विसेज़ और कंट्रोलर्स को एक ही जगह पर शुरू करने के लिए
/// GetX बाइंडिंग क्लास। यह सबसे सही तरीका है।
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // यहाँ डाले गए सभी कंट्रोलर और सर्विस सही क्रम में और सही समय पर बनेंगे।
    Get.put(NetworkController(), permanent: true);
    Get.put(CartService(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(OrderService(), permanent: true);
    Get.put(UserOrdersController(), permanent: true);
    Get.put(OrderDetailsController(), permanent: true);

    // AuthProvider, जो एक सामान्य क्लास है, उसे भी यहीं रजिस्टर करें
    Get.put(AppAuthProvider(), permanent: true);

    // HomeController, जो हमेशा चलेगा
    Get.put(HomeController(), permanent: true);

    // NotificationService को async तरीके से शुरू करें
    Get.putAsync(() => NotificationService().init(), permanent: true);
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // बैकग्राउंड नोटिफिकेशन के लिए हैंडलर सेट करें
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTHeme,

      // <<<--- यह सबसे महत्वपूर्ण बदलाव है ---<<<
      // अब हम GetX को बता रहे हैं कि ऐप शुरू होने पर `AppBindings` का उपयोग करे।
      initialBinding: AppBindings(),

      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        // यह UI आपके नो-इंटरनेट विजेट के लिए है, यह सही है
        final networkController = Get.find<NetworkController>();
        return Obx(() {
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (!networkController.isConnected) const NoInternetWidget(),
            ],
          );
        });
      },
    );
  }
}
