// lib/UI/Widgets/Organisms/product_description_modal_opener.dart

import 'package:flutter/material.dart';
import 'package:ssda/app_colors.dart';
import 'package:ssda/constants.dart';
import 'package:ssda/models/product_model.dart';
import 'package:ssda/UI/Widgets/Atoms/add_to_cart_button.dart';

// यह एक हेल्पर फंक्शन है जो बॉटम शीट को खोलता है
void openProductDescription(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6, // शुरुआती ऊंचाई 60%
      maxChildSize: 0.9,     // अधिकतम ऊंचाई 90%
      minChildSize: 0.4,     // न्यूनतम ऊंचाई 40%
      builder: (context, scrollController) =>
          ProductDescriptionModal(product: product, scrollController: scrollController),
    ),
  );
}

class ProductDescriptionModal extends StatelessWidget {
  final Product product;
  final ScrollController scrollController;

  const ProductDescriptionModal({super.key, required this.product, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double priceAsDouble = double.tryParse(product.price) ?? 0.0;
    final double regularPriceAsDouble = double.tryParse(product.regularPrice) ?? 0.0;
    final bool onSale = product.onSale && regularPriceAsDouble > priceAsDouble;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        controller: scrollController,
        children: [
          // ड्रैग हैंडल
          Center(
            child: Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          // प्रोडक्ट इमेज
          SizedBox(
            height: 200,
            width: double.infinity,
            child: product.image.isNotEmpty
                ? Image.network(product.image, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 100, color: Colors.grey),
            )
                : const Icon(Icons.image_not_supported_outlined, size: 100, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // प्रोडक्ट का नाम
          Text(product.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // प्रोडक्ट का विवरण
          if (product.description.isNotEmpty)
            Text(
              product.description,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
            ),
          const Divider(height: 30),
          // कीमत और ऐड टू कार्ट बटन
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$appCurrencySybmbol${priceAsDouble.toStringAsFixed(2)}",
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryGreenColor),
                  ),
                  if (onSale)
                    Text(
                      "$appCurrencySybmbol${regularPriceAsDouble.toStringAsFixed(2)}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              buildAddToCartButton(product),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}