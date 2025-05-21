import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:ssda/app_colors.dart';
import 'package:ssda/services/cart_service.dart';

class BottomStickyContainer extends StatelessWidget {
  const BottomStickyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Try reading CartService here directly — with context.watch
    final cart = context.watch<CartService>();
    final totalItems = cart.totalItems;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.greyWhiteColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems ITEM${totalItems > 1 ? "S" : ""}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Builder(
                builder: (context) {
                  return TextButton(
                    onPressed: () {
                      Get.toNamed('/cart'); // ✅ correct, if GetMaterialApp used
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: AppColors.primaryGreenColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
