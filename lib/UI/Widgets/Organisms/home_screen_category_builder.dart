import 'package:flutter/material.dart';
import 'package:ssda/models/category_model.dart';
import 'package:ssda/services/category_service.dart';
import 'package:ssda/screens/products_screen.dart';

class HomeScreenCateogoryWidget extends StatefulWidget {
  const HomeScreenCateogoryWidget({super.key});

  @override
  State<HomeScreenCateogoryWidget> createState() => _HomeScreenCateogoryWidgetState();
}

class _HomeScreenCateogoryWidgetState extends State<HomeScreenCateogoryWidget> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryService().getMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else {
          final categories = snapshot.data!;
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          categoryName: category.name,
                          categoryId: category.id,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      category.imageUrl != null
                          ? Image.network(category.imageUrl!, height: 50, width: 50)
                          : const Icon(Icons.image_not_supported, size: 50),
                      const SizedBox(height: 5),
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
              childCount: categories.length,
            ),
          );
        }
      },
    );
  }
}
