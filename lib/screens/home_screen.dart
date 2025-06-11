import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../UI/Widgets/Atoms/home_screen_floating_button.dart';
import '../UI/Widgets/Organisms/bottom_cart_container.dart';
import '../UI/Widgets/Organisms/category_with_products.dart';
import '../UI/Widgets/Organisms/home_screen_app_bar.dart';
import '../UI/Widgets/Organisms/home_screen_category_builder.dart';
import '../UI/Widgets/Organisms/home_screen_search_bar.dart';
import '../UI/Widgets/Organisms/home_screen_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 3,

      ),
      floatingActionButton: HomeScreenFloatingNavigationBar(),
      primary: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              HomeScreenAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const HomeScreenSearchBar(),
                ),
              ),
              HomeScreenCarousel(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 5,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              HomeScreenCateogoryWidget(),
              CatgorywithProducts(products: [],),
              CatgorywithProducts(
                title: "Personal Care", products: [],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 90,
                ),
              ),
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
}
