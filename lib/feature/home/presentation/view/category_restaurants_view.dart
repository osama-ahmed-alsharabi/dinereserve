import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/restaurant_card_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/category_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/data/get_restaurant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRestaurantsView extends StatelessWidget {
  final String categoryName;

  const CategoryRestaurantsView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryCubit(GetRestaurantRepo(getIt.get<SupabaseClient>()))
            ..getRestaurantsByType(categoryName),
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategorySuccess) {
              if (state.restaurants.isEmpty) {
                return Center(child: Text("No $categoryName found"));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
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
                ),
              );
            } else if (state is CategoryFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
