import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // <<<--- GetX के लिए इम्पोर्ट करें
import 'package:ssda/UI/Widgets/Atoms/custom_text_field.dart';
import 'package:ssda/app_colors.dart' show AppColors;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ssda/Services/Providers/custom_auth_provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key, this.data});
  final dynamic data;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late TextEditingController _otpController;
  int _secondsRemaining = 30;
  late Timer _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
  }

  Future<void> _verifyOTP(BuildContext context, String value) async {
    if (_isLoading) return;
    setState(() { _isLoading = true; });

    try {
      String verificationId = widget.data['verificationId'];
      String smsCode = value;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);

      // --- <<< यहाँ महत्वपूर्ण बदलाव किया गया है >>> ---
      // नया इंस्टेंस बनाने के बजाय, GetX से मौजूदा इंस्टेंस प्राप्त करें।
      final authProvider = Get.find<AppAuthProvider>();
      await authProvider.onOtpVerified(cred);

      // GetX का उपयोग करके नेविगेट करें ताकि यह सुसंगत रहे
      Get.offAllNamed('/homenav');

    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP Verification Failed: ${e.toString()}")),
        );
      }
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_secondsRemaining <= 1) {
          timer.cancel();
          setState(() {});
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  void _restartTimer() {
    if (_timer.isActive) _timer.cancel();
    setState(() { _secondsRemaining = 30; });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const Text("We've sent aaa a verification code to "),
            Text(
              "+91 ${widget.data['phoneNumber']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            customTextField(
              hintText: "Please enter OTP",
              isPhoneNumberField: true,
              maxLength: 6,
              textEditingController: _otpController,
              onFieldSubmitted: _isLoading ? null : (value) {
                if (value != null && value.length == 6) {
                  _verifyOTP(context, value);
                }
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive code? "),
                  if (_secondsRemaining < 2)
                    TextButton(
                      onPressed: _restartTimer,
                      child: const Text("Resend OTP"),
                    )
                  else
                    Text("Resend in $_secondsRemaining s"),
                ],
              )
          ],
        ),
      ),
    );
  }
}
