// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:app_links/app_links.dart';
// import 'package:ssda/Services/Providers/custom_auth_provider.dart';
// import 'package:ssda/models/news_article_model.dart';
// import 'package:ssda/screens/intro-screen/homenav.dart';
// import 'package:ssda/screens/intro-screen/login-mobile-number.dart';
// import 'package:ssda/screens/news_detail_screen.dart';
// import 'package:ssda/services/news_service.dart';
//
// class SplashController extends GetxController {
//   final _appLinks = AppLinks();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _handleStartupLogic();
//   }
//
//   Future<void> _handleStartupLogic() async {
//     // 1. सबसे पहले डीप लिंक की जांच करें
//     try {
//       final initialUri = await _appLinks.getInitialLink();
//       if (initialUri != null) {
//         await _handleDeepLink(initialUri);
//         return;
//       }
//     } on PlatformException {
//       print('Failed to get initial deep link.');
//     }
//
//     // 2. अगर कोई डीप लिंक नहीं है, तो 2 सेकंड रुककर यूजर का लॉग-इन स्टेटस जांचें
//     await Future.delayed(const Duration(seconds: 2));
//
//     final authProvider = Get.find<AppAuthProvider>();
//     if (authProvider.isUserLoggedIn) {
//       Get.offAll(() => HomeNav(index: 0));
//     } else {
//       Get.offAll(() => const MobileNumber());
//     }
//   }
//
//   Future<void> _handleDeepLink(Uri deepLink) async {
//     String? articleIdString = deepLink.queryParameters['p'] ?? deepLink.queryParameters['id'];
//     if (articleIdString != null) {
//       final articleId = int.tryParse(articleIdString);
//       if (articleId != null) {
//         final NewsArticle? article = await NewsService.getArticleById(articleId);
//         if (article != null) {
//           // पहले होम पर भेजें, फिर न्यूज़ स्क्रीन दिखाएं ताकि बैक करने पर होम आए
//           Get.offAll(() => HomeNav(index: 0), transition: Transition.noTransition);
//           Get.to(() => NewsDetailScreen(article: article));
//         } else {
//           Get.offAll(() => HomeNav(index: 0));
//         }
//       } else {
//         Get.offAll(() => HomeNav(index: 0));
//       }
//     } else {
//       Get.offAll(() => HomeNav(index: 0));
//     }
//   }
// }