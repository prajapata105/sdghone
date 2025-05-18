import 'package:flutter/material.dart';
import 'package:ssda/models/product_model.dart';
import '../Atoms/card_product_list.dart';

class CatgorywithProducts extends StatelessWidget {
  final String? title;
  final List<Product> products;

  const CatgorywithProducts({
    super.key,
    this.title = "Milk and Breads",
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return ProductCardForList(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
