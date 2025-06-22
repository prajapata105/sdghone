import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/app_theme.dart';
import 'package:ssda/controller/AddressController.dart';
import 'package:ssda/controller/HomeController.dart';
import 'package:ssda/controller/OrderDetailsController.dart';
import 'package:ssda/controller/UserOrdersController.dart';
import 'package:ssda/controller/network_controller.dart';
import 'package:ssda/route_generator.dart';
import 'package:ssda/services/OrderService.dart';
import 'package:ssda/services/cart_service.dart';
import 'package:ssda/Services/Providers/custom_auth_provider.dart';
import 'package:ssda/ui/widgets/common/no_internet_widget.dart';
import 'package:ssda/screens/intro-screen/splasescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // <<<--- AuthProvider का नाम AppAuthProvider से बदला गया ---<<<
  Get.put(AppAuthProvider(), permanent: true);
  Get.put(NetworkController(), permanent: true);
  Get.put(CartService(), permanent: true);
  Get.put(AddressController(), permanent: true);
  Get.put(OrderService(), permanent: true);
  Get.put(UserOrdersController(), permanent: true);
  Get.put(OrderDetailsController(), permanent: true);
  Get.put(HomeController(), permanent: true);

  runApp(const MyApp());
}

// MyApp अब Stateless है क्योंकि सारा लॉजिक स्प्लैश और होम कंट्रोलर में है
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ऐप के चलते रहने के दौरान आने वाले लिंक्स को सुनने का लॉजिक
    Get.find<HomeController>().setupAppLinkListener();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTHeme,
      // <<<--- बदलाव यहाँ: अब हम onGenerateRoute का उपयोग करेंगे ---<<<
      initialRoute: '/', // ऐप हमेशा स्प्लैशस्क्रीन ('/') से शुरू होगी
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
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

