import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/services/cart_service.dart';

class CartPriceDetailWidget extends StatelessWidget {
  const CartPriceDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Get.find<CartService>();

    return Obx(() {
      final subtotal = cartService.subtotal;
      final discount = cartService.appliedCoupon.value?.amount?.toDouble() ?? 0.0;
      double delivery = cartService.deliveryCharge; // अब error नहीं आएगा
      final grandTotal = (subtotal - discount + delivery).clamp(0, double.infinity);

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bill Details",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            _buildPriceRow("Subtotal", subtotal),
            if (discount > 0)
              _buildPriceRow("Coupon Discount", -discount, isDiscount: true),
            _buildPriceRow("Delivery", delivery),
            const Divider(thickness: 1, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "₹${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildPriceRow(String label, double value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            (isDiscount ? "- " : "") + "₹${value.abs().toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              color: isDiscount ? Colors.green : Colors.black,
              fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
