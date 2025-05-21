import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssda/app_colors.dart';
import 'package:ssda/models/cart_item_model.dart';
import 'package:ssda/services/cart_service.dart';

class CartProductCard extends StatelessWidget {
  final CartItem cartItem;

  const CartProductCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartService>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product image and details
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Image.network(cartItem.product.image, height: 70),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('300gms'),
                  Text(
                    '₹ ${cartItem.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),

          // Quantity controls
          Container(
            height: 30,
            width: 105,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => cart.decreaseQuantity(cartItem.product),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                ),
                Text("${cartItem.quantity}", style: const TextStyle(color: Colors.white)),
                IconButton(
                  onPressed: () => cart.increaseQuantity(cartItem.product),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

