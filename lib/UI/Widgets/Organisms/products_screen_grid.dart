import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import '../Atoms/card_product.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  const ProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              final product = products[index];
              return ProductCard(product: product); // ✅ proper object
            },
            childCount: products.length,
          ),
        )
      ],
    );
  }
}
