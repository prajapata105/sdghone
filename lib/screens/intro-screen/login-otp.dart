import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/utils/constent.dart';
import 'package:ssda/weight/snapkbar.dart';
import 'homenav.dart';
import 'login-mobile-number.dart';

class OtpScreen extends StatefulWidget {
  String verfyid;
  OtpScreen({super.key, required this.verfyid});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var optcode = "";
  final auth = FirebaseAuth.instance;
  var size, w, h;
  Snakbar snakbar = Snakbar();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.05),
                Text('Verification Code', style: Maintital),
                SizedBox(height: h * 0.001),
                Text('We have sent the verification code to', style: smalltital),
                SizedBox(height: h * 0.02),
                Row(
                  children: [
                    Text(
                      '+91${MobileNumber.phonenumber}',
                      style: const TextStyle(
                          fontSize: 15,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: w * 0.02),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Change Phone number?",
                        style: const TextStyle(
                            fontSize: 15,
                            color: kBlackColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.1),

                /// 🔁 Replaced Pinput with basic TextField
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Enter 6-digit OTP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    optcode = value;
                  },
                ),

                SizedBox(height: h * 0.03),
                SizedBox(height: h * 0.14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: h * 0.062,
                      width: w * 0.40,
                      decoration: BoxDecoration(
                        color: ksubprime,
                        boxShadow: [
                          BoxShadow(color: kPrimaryColor, blurRadius: 7)
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Resend',
                        style: TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final crediantion = PhoneAuthProvider.credential(
                            verificationId: widget.verfyid,
                            smsCode: optcode);
                        try {
                          await auth.signInWithCredential(crediantion);
                          Get.off(HomeNav(index: 0));
                        } catch (e) {
                          snakbar.snakbarsms('ओटीपी गलत है');
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: h * 0.062,
                        width: w * 0.40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(color: kPrimaryColor, blurRadius: 7)
                          ],
                          color: ksubprime,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// TODO Implement this library.