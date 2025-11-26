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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeAppBarWidget(),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeSearchWidget(),
            ),
            const SizedBox(height: 24),
            const QuickCategoriesWidget(),
            const SizedBox(height: 24),
            // Banner Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://img.freepik.com/free-vector/flat-design-food-banner-template_23-2149076251.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FeaturedRestaurantsWidget(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
