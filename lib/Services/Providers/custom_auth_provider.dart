import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/services/WooUserMapper.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();

  String? wooUserId;

  // OTP Verification Success Callback
  Future<void> onOtpVerified(UserCredential cred) async {
    String firebaseUid = cred.user!.uid;
    String phone = cred.user!.phoneNumber!;
    // 1. Woo user id find/create & local में save
    wooUserId = await WooUserMapper.mapFirebaseToWooUser(phone: firebaseUid, name: phone);
    box.write('wooUserId', wooUserId);
    // अब wooUserId सभी Address, Orders आदि में पास करो
  }

  String? getWooUserId() {
    return wooUserId ?? box.read('wooUserId');
  }
}
