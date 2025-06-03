import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/app_colors.dart';
import 'package:ssda/models/cart_item_model.dart';
import 'package:ssda/services/cart_service.dart';

class CartProductCard extends StatelessWidget {
  final CartItem cartItem;
  const CartProductCard({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT: Product image and details (takes all available width)
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    cartItem.imageUrl,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Important for long text
                        maxLines: 1,
                      ),
                      if (cartItem.variation != null)
                        Text(
                          '${cartItem.variation!}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      Text(
                        '₹ ${cartItem.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // RIGHT: Quantity controls (Fixed width)
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 36,
            width: 108,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (cartItem.quantity > 1) {
                      cart.updateQuantity(cartItem, cartItem.quantity - 1);
                    } else {
                      cart.removeFromCart(cartItem);
                    }
                  },
                  icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                ),
                Text(
                  "${cartItem.quantity}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    cart.updateQuantity(cartItem, cartItem.quantity + 1);
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
