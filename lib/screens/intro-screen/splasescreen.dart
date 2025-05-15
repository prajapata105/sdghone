import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'homenav.dart';
import 'login-mobile-number.dart';
class SplaseScreen extends StatefulWidget {
  const SplaseScreen({Key? key}) : super(key: key);

  @override
  State<SplaseScreen> createState() => _SplaseScreenState();
}

class _SplaseScreenState extends State<SplaseScreen> {
  var size,w,h;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),(){
      if(FirebaseAuth.instance.currentUser?.uid  !=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeNav(index: 0)));
      }else{
        Get.offAll(MobileNumber());
      }
    });
    // if (FirebaseAuth.instance.currentUser?.uid != null) {
    //   WidgetsBinding.instance.addPersistentFrameCallback((_) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeNav(index: 0)));
    //   });
    // } else{
    //   Get.offAll(const MobileNumber());
    //   // Future.delayed(const Duration(seconds: 2), () {
    //   //   Get.offAll(const MobileNumber());
    //   // });
    // }
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      backgroundColor: Color(0xff161C29),
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: h*0.2,),
          Center(child: Image.asset('assets/imagesvg/logoSdghone.png')),
          SizedBox(height: h*0.3 ,),
          Text('श्री डूंगरगढ़ हमारा शहर',style: TextStyle(fontSize:19,color: Colors.white),),
        ],),
      ),
    );
  }
}
