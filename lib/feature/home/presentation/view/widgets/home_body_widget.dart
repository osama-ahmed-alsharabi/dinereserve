import 'package:dinereserve/feature/home/presentation/view/widgets/featured_restaurants_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_app_bar_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_search_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/quick_categories_widget.dart';
import 'package:flutter/material.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBarWidget(),
            const SizedBox(height: 24),
            const HomeSearchWidget(),
            const SizedBox(height: 24),
            const QuickCategoriesWidget(),
            const SizedBox(height: 24),
            // Banner Placeholder
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://img.freepik.com/free-vector/flat-design-food-banner-template_23-2149076251.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const FeaturedRestaurantsWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
