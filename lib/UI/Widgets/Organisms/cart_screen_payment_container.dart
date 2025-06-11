// lib/UI/Widgets/Organisms/cart_screen_payment_container.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/controller/CheckoutController.dart';
import '../../../app_colors.dart';

class CartScreenPaymentContainer extends StatelessWidget {
  const CartScreenPaymentContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutCtrl = Get.put(CheckoutController());
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.payment, color: Colors.orangeAccent),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment Method", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    checkoutCtrl.selectedPaymentMethod.value == 'cod'
                        ? "Cash on Delivery"
                        : "Pay Online",
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              )
            ],
          ),
          checkoutCtrl.isLoading.value
              ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreenColor),
            ),
          )
              : ElevatedButton(
            // 👇 कंट्रोलर में परिभाषित मेथड का सही नाम उपयोग करें
            onPressed: checkoutCtrl.placeOrderFlow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreenColor,
              foregroundColor: AppColors.greyWhiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: const Text("Place Order"),
          )
        ],
      )),
    );
  }
}