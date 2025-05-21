import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ssda/models/product_model.dart';
import 'package:ssda/services/cart_service.dart';
import '../../../app_colors.dart';

Widget buildAddToCartButton(Product product) {
  return Consumer<CartService>(
    builder: (context, cart, _) {
      return InkWell(
        onTap: () {
          cart.addToCart(product);
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
    },
  );
}
