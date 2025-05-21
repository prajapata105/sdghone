import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import '../Atoms/add_to_cart_button.dart';

Future<dynamic> openProductDescription(BuildContext parentContext, Product product) {
  return showModalBottomSheet(
    context: parentContext,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    builder: (modalContext) {
      return Builder(
        builder: (correctContext) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: product.image.isNotEmpty
                              ? Image.network(product.image, height: 200)
                              : const Placeholder(fallbackHeight: 200),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            // ✅ Correct scoped context use कर रहे हैं
                            buildAddToCartButton(product),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Product Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : 'No description available',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
