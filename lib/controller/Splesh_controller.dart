import 'dart:async';

import 'package:get/get.dart';

import 'package:ssda/Services/Providers/custom_auth_provider.dart';

import 'package:ssda/screens/intro-screen/homenav.dart';
import 'package:ssda/screens/intro-screen/login-mobile-number.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 2));
    final authProvider = Get.find<AppAuthProvider>();
    if (authProvider.isUserLoggedIn) {
      Get.offAll(() => HomeNav(index: 0));
    } else {
      Get.offAll(() => const MobileNumber());
    }
  }
}

