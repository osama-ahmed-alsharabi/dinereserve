import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/restaurant_card_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedRestaurantsWidget extends StatelessWidget {
  const FeaturedRestaurantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Restaurants",
              style: context.textStyle.text20Mediam.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeSuccess) {
              if (state.restaurants.isEmpty) {
                return const Center(child: Text("No restaurants found"));
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  return RestaurantCardWidget(
                    restaurant: state.restaurants[index],
                  );
                },
              );
            } else if (state is HomeFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
