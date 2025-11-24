import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/profile_restaurant/data/get_restaurant_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/edit_profile_restaurant_view.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRestaurantEditButton extends StatelessWidget {
  const ProfileRestaurantEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            final state = context.read<GetRestaurantCubit>().state;
            if (state is GetRestaurantSuccess) {
              final restaurant = state.restaurant;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => GetRestaurantCubit(
                      GetRestaurantRepo(getIt.get<SupabaseClient>()),
                    ),
                    child: EditProfileRestaurantView(restaurant: restaurant),
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Edit Restaurant",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
