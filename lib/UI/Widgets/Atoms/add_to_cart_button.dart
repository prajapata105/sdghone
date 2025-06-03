import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ssda/app_colors.dart';
import 'package:ssda/models/product_model.dart';
import 'package:ssda/models/cart_item_model.dart';
import 'package:ssda/services/cart_service.dart';

Widget buildAddToCartButton(Product product) {
  // आप चाहें तो यह function stateless widget बना सकते हैं
  return InkWell(
    onTap: () {
      final cart = Get.find<CartService>();
      // CartItem model में product से mapping करें:
      final cartItem = CartItem(
        id: product.id,
        title: product.name,
        imageUrl: product.image, // या product.images[0] अपने model के हिसाब से
        price: product.price.toDouble(),
        quantity: 1,
      );
      cart.addToCart(cartItem);
      Fluttertoast.showToast(
        msg: 'Product Added To Cart',
        backgroundColor: Colors.white,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenColor.withOpacity(0.1),
        border: Border.all(color: AppColors.primaryGreenColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          fontSize: 15,
          color: AppColors.primaryGreenColor,
        ),
      ),
    ),
  );
}
