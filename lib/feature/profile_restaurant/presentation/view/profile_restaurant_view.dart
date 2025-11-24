import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/profile_restaurant_header.dart';
import 'widgets/profile_restaurant_info.dart';
import 'widgets/profile_restaurant_features.dart';
import 'widgets/profile_restaurant_edit_button.dart';
import 'widgets/profile_restaurant_food.dart';

class ProfileRestaurantView extends StatelessWidget {
  final bool isReadOnly;
  final RestaurantModel? restaurantModel; // For read-only mode

  const ProfileRestaurantView({
    super.key,
    this.isReadOnly = false,
    this.restaurantModel,
  });

  @override
  Widget build(BuildContext context) {
    if (isReadOnly && restaurantModel != null) {
      return _buildContent(context, restaurantModel!);
    }

    return BlocBuilder<GetRestaurantCubit, GetRestaurantState>(
      builder: (context, state) {
        if (state is GetRestaurantSuccess) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<GetRestaurantCubit>().fetchRestaurant(),
            child: _buildContent(context, state.restaurant),
          );
        } else if (state is GetRestaurantFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, RestaurantModel restaurant) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRestaurantHeader(images: restaurant.images),
            const SizedBox(height: 20),
            ProfileRestaurantInfo(restaurant: restaurant),
            const SizedBox(height: 20),
            ProfileRestaurantFeatures(features: restaurant.features),
            const SizedBox(height: 20),
            ProfileRestaurantFood(menu: restaurant.menu),
            const SizedBox(height: 20),
            if (!isReadOnly) ...[
              const ProfileRestaurantEditButton(),
              const SizedBox(height: 80),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await getIt.get<RestaurantLocalService>().logout();
                    if (context.mounted) {
                      context.goNamed(AppRouterConst.loginViewRouteName);
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Booking logic to be implemented later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking coming soon!")),
                      );
                    },
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
