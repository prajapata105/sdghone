import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssda/Services/cart_service.dart';
import 'package:ssda/UI/Widgets/Organisms/cart_screen_address_container.dart';
import 'package:ssda/UI/Widgets/Organisms/cart_screen_payment_container.dart';
import 'package:ssda/UI/Widgets/Organisms/card_cart_prices_detail.dart';
import 'package:ssda/UI/Widgets/Organisms/card_cart_time_total_items.dart';
import 'package:ssda/UI/Widgets/Atoms/card_gift_cart_screen.dart';
import 'package:ssda/UI/Widgets/Atoms/card_cancellation_policy.dart';
import 'package:ssda/UI/Widgets/Atoms/card_product_cart_screen.dart';
import 'package:ssda/UI/Widgets/Organisms/card_apply_coupon.dart';
import 'package:ssda/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartService>();
    print("cartItems length = ${context.watch<CartService>().cartItems.length}"); // ⬅️ देख लो context मिल रहा या नहीं
    return Scaffold(
      backgroundColor: AppColors.greyWhiteColor,
      appBar: AppBar(
        leadingWidth: 25,
        automaticallyImplyLeading: true,
        title: const Text("Checkout"),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              const CartTimeandTotalItemCard(),

              // ✅ Real Cart Products
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.cartItems[index];
                    return CartProductCard(cartItem: cartItem);
                  },
                ),
              ),

              const ApplyCouponOnCartCard(),
              const CartPriceDetailWidget(),
              const OrderGiftCard(),
              const CancellationPolicyCard(),

              const SizedBox(height: 150),
            ],
          ),

          const Positioned(
            bottom: 0,
            child: Column(
              children: [
                CartScreenAddressContainer(),
                CartScreenPaymentContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
