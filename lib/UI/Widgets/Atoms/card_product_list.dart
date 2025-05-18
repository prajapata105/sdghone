import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import '../Organisms/product_description_modal_opener.dart';
import 'add_to_cart_button.dart';

class ProductCardForList extends StatelessWidget {
  final Product product;

  const ProductCardForList({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openProductDescription(context, product);
      },
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: product.image.isNotEmpty
                    ? Image.network(product.image, width: 100)
                    : const Placeholder(fallbackHeight: 100),
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("300gms"),
            Row(
              children: [
                Text("₹ ${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 2),
                const Text("₹ 120", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 15),
            buildAddToCartButton()
          ],
        ),
      ),
    );
  }
}
