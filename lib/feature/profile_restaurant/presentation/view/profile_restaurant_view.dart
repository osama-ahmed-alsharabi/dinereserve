import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
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
  const ProfileRestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRestaurantCubit, GetRestaurantState>(
      builder: (context, state) {
        if (state is GetRestaurantSuccess) {
          final RestaurantModel restaurant = state.restaurant;
          return RefreshIndicator(
            onRefresh: () =>
                context.read<GetRestaurantCubit>().fetchRestaurant(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileRestaurantHeader(images: restaurant.images),
                  SizedBox(height: 20),
                  ProfileRestaurantInfo(restaurant: restaurant),
                  SizedBox(height: 20),
                  ProfileRestaurantFeatures(features: restaurant.features),
                  SizedBox(height: 20),
                  ProfileRestaurantFood(menu: restaurant.menu),
                  SizedBox(height: 20),
                  ProfileRestaurantEditButton(),
                  SizedBox(height: 80),
                  Center(
                    child: TextButton.icon(
                      onPressed: () async {
                        await getIt.get<RestaurantLocalService>().logout();
                        if (context.mounted) {
                          GoRouter.of(context).go('/loginRest');
                        }
                      },
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        } else if (state is GetRestaurantFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
