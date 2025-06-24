import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ssda/Infrastructure/HttpMethods/requesting_methods.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ [BACKGROUND HANDLER] Background message handled: ${message.messageId}");
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;

  Future<NotificationService> init() async {
    await _fcm.requestPermission();
    _fcmToken = await _fcm.getToken();
    print("✅ [NotificationService] FCM Token: $_fcmToken");

    await _initializeLocalNotifications();
    _setupMessageHandlers();
    _handleTerminatedStateClick();

    return this;
  }

  Future<void> sendTokenToServer() async {
    if (_fcmToken == null) {
      print("❌ [NotificationService] FCM token is null, can't send to server.");
      return;
    }
    try {
      const String url = "https://sridungargarhone.com/wp-json/my-app/v1/save-fcm-token";

      // <<<--- यहाँ isAuthorize: true जोड़ें ---<<<
      await ApiService.requestMethods(
        url: url,
        methodType: "POST",
        body: {'fcm_token': _fcmToken},
        isAuthorize: true, // यह सुनिश्चित करेगा कि ApiService टोकन भेजे
      );
      print("✅ [NotificationService] FCM token successfully sent to the server.");
    } catch (e) {
      print("❌ [NotificationService] Failed to send FCM token to server: $e");
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print("✅ [NotificationService] Foreground notification tapped. Payload: ${response.payload}");
        if (response.payload != null && response.payload!.isNotEmpty) {
          final data = jsonDecode(response.payload!);
          _handleNotificationClick(Map<String, dynamic>.from(data));
        }
      },
    );
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("✅ [NotificationService] Foreground Message Received!");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("✅ [NotificationService] Notification TAPPED from BACKGROUND state!");
      _handleNotificationClick(message.data);
    });
  }

  Future<void> _handleTerminatedStateClick() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("✅ [NotificationService] Notification TAPPED from TERMINATED state!");
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationClick(initialMessage.data);
      });
    }
  }

  void _showLocalNotification(RemoteMessage message) async {
    // ... (यह फंक्शन वैसा ही रहेगा) ...
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    // <<<--- यहाँ डीबग करने के लिए प्रिंट स्टेटमेंट जोड़ा गया है ---<<<
    print("➡️ [NotificationService] _handleNotificationClick called with data: $data");

    final String? type = data['type'];
    final String? id = data['id'];
    String? deepLinkPath;

    if (type != null && id != null) {
      if (type == 'news') {
        deepLinkPath = '/?p=$id';
      } else if (type == 'product') {
        deepLinkPath = '/?product_id=$id';
      }
    }

    if (deepLinkPath == null && data['click_action'] != null) {
      deepLinkPath = data['click_action'];
    }

    if (deepLinkPath != null) {
      print("➡️ [NotificationService] Navigating to path: $deepLinkPath");
      Get.toNamed(deepLinkPath);
    } else {
      print("❌ [NotificationService] Could not determine navigation path from notification data.");
    }
  }
}
