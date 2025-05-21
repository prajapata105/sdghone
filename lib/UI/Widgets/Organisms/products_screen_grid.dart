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
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (index == products.length) return const SizedBox(height: 50);
              return ProductCard(product: products[index]);
            },
            childCount: products.length + 1,
          ),
        ),
      ],
    );
  }
}
