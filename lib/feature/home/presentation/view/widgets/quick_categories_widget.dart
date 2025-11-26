import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/feature/home/presentation/view/category_restaurants_view.dart';
import 'package:flutter/material.dart';

class QuickCategoriesWidget extends StatelessWidget {
  const QuickCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.restaurant, 'label': 'Restaurant'},
      {'icon': Icons.local_cafe, 'label': 'Cafe'},
      {'icon': Icons.cake, 'label': 'Sweets Shop'},
      {'icon': Icons.fastfood, 'label': 'Fast Food'},
      {'icon': Icons.bakery_dining, 'label': 'Bakery'},
      {'icon': Icons.outdoor_grill, 'label': 'Grill'},
      {'icon': Icons.breakfast_dining, 'label': 'Breakfast House'},
      {'icon': Icons.local_drink, 'label': 'Juice Shop'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quick Categories",
                style: context.textStyle.text20Mediam.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryRestaurantsView(
                        categoryName: cat['label'] as String,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['label'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
