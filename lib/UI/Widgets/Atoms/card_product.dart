import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import 'add_to_cart_button.dart';
import '../Organisms/product_description_modal_opener.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openProductDescription(context, product); // ✅ Make sure this method exists
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image.isNotEmpty
                ? Image.network(product.image, height: 120)
                : const Placeholder(fallbackHeight: 120),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Text("1 item"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      buildAddToCartButton()
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
