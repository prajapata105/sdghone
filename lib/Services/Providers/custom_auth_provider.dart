import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/Infrastructure/HttpMethods/requesting_methods.dart';
import 'package:ssda/services/notification_service.dart';
import 'package:ssda/services/WooUserMapper.dart';

class AppAuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();

  // isUserLoggedIn अब authToken की जांच करेगा, जो ज़्यादा विश्वसनीय है
  final Rxn<String> wooUserId = Rxn<String>();

  bool get isUserLoggedIn => box.read('authToken') != null;
  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    // ऐप शुरू होते ही स्टोरेज से यूजर ID लोड करें
    final storedUserId = box.read<String>('wooUserId');
    if (storedUserId != null) {
      wooUserId.value = storedUserId;
    }
  }
  /// OTP वेरिफिकेशन के बाद यह फंक्शन कॉल होता है और सब कुछ हैंडल करता है।
  Future<bool> onOtpVerified(UserCredential cred) async {
    try {
      final firebaseUser = cred.user;
      if (firebaseUser == null || firebaseUser.phoneNumber == null) {
        throw Exception("Firebase user or phone number is null.");
      }

      // 1. वर्डप्रेस से JWT टोकन और यूज़र की जानकारी प्राप्त करें
      final response = await ApiService.requestMethods(
        url:
        "https://sridungargarhone.com/wp-json/jwt-auth/v1/token_firebase?phone=${firebaseUser.phoneNumber!}",
        methodType: "POST",
      );

      if (response != null && response['token'] != null) {
        // --- <<< 2. (सबसे महत्वपूर्ण) JWT टोकन को GetStorage में सेव करें >>> ---
        await box.write('authToken', response['token']);
        print("✅ [AppAuthProvider] JWT auth token saved successfully.");

        // 3. WooCommerce यूज़र ID को सेव करें
        // हम उसी response से ID लेंगे जो JWT टोकन के साथ आई है
        await box.write('wooUserId', response['user_id']);
        print("✅ [AppAuthProvider] User mapped. wooUserId: ${response['user_id']}");

        // 4. (अब यह काम करेगा) FCM टोकन को अपने वर्डप्रेस सर्वर पर भेजें
        try {
          final notificationService = Get.find<NotificationService>();
          await notificationService.sendTokenToServer();
        } catch (e) {
          print("❌ [AppAuthProvider] Error sending FCM token: $e");
        }

        return true; // लॉगिन सफल हुआ
      } else {
        throw Exception("Failed to get JWT token from WordPress.");
      }

    } catch (e) {
      print("❌ [AppAuthProvider] Error during onOtpVerified: $e");
      return false; // लॉगिन असफल हुआ
    }
  }

  /// यूज़र को लॉग आउट करता है।
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await box.remove('wooUserId');
      await box.remove('authToken'); // <<<--- authToken को भी हटाएं
      print("User logged out and local data cleared.");
    } catch (e) {
      print("Error during logout: $e");
      throw Exception('Logout Failed: $e');
    }
  }
  String? getWooUserId() {
    return wooUserId.value;
  }
}