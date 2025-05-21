import 'package:flutter/material.dart';
import 'package:ssda/Services/category_service.dart';
import 'package:ssda/UI/Widgets/Organisms/bottom_cart_container.dart';
import 'package:ssda/UI/Widgets/Organisms/products_screen_grid.dart';
import 'package:ssda/UI/Widgets/Organisms/products_screen_sub_category_list.dart';
import 'package:ssda/UI/custom_search_delegate.dart';
import 'package:ssda/app_colors.dart' show AppColors;

import '../../models/product_model.dart'; // ✅ lowercase only
import '../../services/product_service.dart';
import '../models/category_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.categoryName,this.categoryId});

  final String categoryName;
  final int? categoryId;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService productService = ProductService();
  late Future<List<Product>> _productsFuture;
  late Future<List<Category>> _subCategoryFuture;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _productsFuture = productService.getAllProductsByCategory(widget.categoryId!);
      _subCategoryFuture = CategoryService().getSubCategories(widget.categoryId!);
    } else {
      _productsFuture = productService.getAllProducts();
      _subCategoryFuture = Future.value([]);
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _productsFuture = productService.getAllProducts(search: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        automaticallyImplyLeading: true,
        title: Text(widget.categoryName),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () async {
          //     final result = await showSearch<String>(
          //       context: context,
          //       delegate: ProductsSearchDelegate(), // ✅ Make sure this class exists
          //     );
          //     if (result != null && result.isNotEmpty) {
          //       _searchProducts(result);
          //     }
          //   },
          // ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: buildSubCategoryList(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found'));
                      } else {
                        return ProductsGrid(products: snapshot.data!);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Builder(
            builder: (context) {
              return const BottomStickyContainer(); // ✅ अब यह context सही है
            },
          ),
        ],
      ),
    );
  }


  Widget buildSubCategoryList() {
    return FutureBuilder<List<Category>>(
      future: _subCategoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final subCategories = snapshot.data!;
          return ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final cat = subCategories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _productsFuture = productService.getAllProductsByCategory(cat.id);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppColors.primaryGreenColor,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.greyWhiteColor,
                        backgroundImage: cat.imageUrl != null
                            ? NetworkImage(cat.imageUrl!)
                            : null,
                        child: cat.imageUrl == null
                            ? const Icon(Icons.image_not_supported)
                            : null,
                      ),
                      Text(cat.name, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

}
