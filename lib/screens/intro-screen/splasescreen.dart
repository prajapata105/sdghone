import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:ssda/Services/Providers/custom_auth_provider.dart';
import 'package:ssda/models/news_article_model.dart';
import 'package:ssda/models/product_model.dart';
import 'package:ssda/screens/news_detail_screen.dart';
import 'package:ssda/services/news_service.dart';
import 'package:ssda/services/product_service.dart';
import 'package:ssda/ui/widgets/organisms/product_description_modal_opener.dart';
import 'homenav.dart';
import 'login-mobile-number.dart';

class SplaseScreen extends StatefulWidget {
  const SplaseScreen({Key? key}) : super(key: key);

  @override
  State<SplaseScreen> createState() => _SplaseScreenState();
}

class _SplaseScreenState extends State<SplaseScreen> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // initState में UI बनने का इंतज़ार करें, फिर लॉजिक चलाएं
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStartup();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleStartup() async {
    // 1. सबसे पहले डीप लिंक की जांच करें (जब ऐप बंद हो)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleDeepLink(initialUri, isInitialLink: true);
        return; // फंक्शन को यहीं खत्म कर दें
      }
    } on PlatformException {
      print('Failed to get initial deep link.');
    }

    // 2. अगर कोई डीप लिंक नहीं है, तो सामान्य स्टार्टअप लॉजिक चलाएं
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final authProvider = Get.find<AppAuthProvider>();
      if (authProvider.isUserLoggedIn) {
        Get.offAll(() => HomeNav(index: 0));
      } else {
        Get.offAll(() => const MobileNumber());
      }
    });

    // 3. ऐप के चलते रहने के दौरान आने वाले लिंक्स को सुनें
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (!mounted) return;
      _handleDeepLink(uri, isInitialLink: false);
    });
  }

  Future<void> _handleDeepLink(Uri deepLink, {required bool isInitialLink}) async {
    print("Deep Link Received: $deepLink");

    // न्यूज़ लिंक की जांच करें (?p= or ?id=)
    String? newsIdString = deepLink.queryParameters['p'] ?? deepLink.queryParameters['id'];
    if (newsIdString != null) {
      final articleId = int.tryParse(newsIdString);
      if (articleId != null) {
        final NewsArticle? article = await NewsService.getArticleById(articleId);
        if (article != null) {
          if (isInitialLink) {
            // सीधे न्यूज़ पेज पर जाएं और पिछली सब स्क्रीन्स हटा दें
            Get.offAll(() => NewsDetailScreen(article: article));
          } else {
            Get.to(() => NewsDetailScreen(article: article));
          }
          return;
        }
      }
    }

    // प्रोडक्ट लिंक की जांच करें (?product_id=)
    String? productIdString = deepLink.queryParameters['product_id'];
    if (productIdString != null) {
      final productId = int.tryParse(productIdString);
      if (productId != null) {
        final Product? product = await ProductService.getProductById(productId);
        if (product != null) {
          if (isInitialLink) {
            // पहले होम स्क्रीन पर भेजें ताकि context मिल सके
            await Get.offAll(() => HomeNav(index: 0), transition: Transition.noTransition);
            // फिर प्रोडक्ट पॉप-अप दिखाएं
            openProductDescription(Get.context!, product);
          } else {
            openProductDescription(Get.context!, product);
          }
          return;
        }
      }
    }

    // अगर कोई लिंक मैच नहीं हुआ, तो होम पर भेजें
    if (isInitialLink) {
      Get.offAll(() => HomeNav(index: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff161C29),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(child: Image.asset('assets/imagesvg/logoSdghone.png')),
            const Spacer(),
            const Text('श्री डूंगरगढ़ हमारा शहर', style: TextStyle(fontSize: 19, color: Colors.white)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}