import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import '../../../app_colors.dart';
import 'add_to_cart_button.dart';
import '../Organisms/product_description_modal_opener.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openProductDescription(context, product),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: product.image.isNotEmpty
                  ? Image.network(product.image, fit: BoxFit.contain)
                  : const Placeholder(),
            ),
            const SizedBox(height: 5),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Text("1 item", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14)),

                Builder(
                  builder: (context) {
                    return   buildAddToCartButton(product);// अब context scoped होगा
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
