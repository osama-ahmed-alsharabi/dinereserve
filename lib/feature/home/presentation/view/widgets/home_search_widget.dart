import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:dinereserve/feature/home/presentation/view/restaurant_search_view.dart';
import 'package:dinereserve/feature/home/presentation/view_model/restaurant_search_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      RestaurantSearchCubit(getIt.get<GetRestaurantRepo>()),
                ),
                BlocProvider(
                  create: (context) =>
                      FavoritesCubit(getIt.get<FavoritesRepo>())
                        ..loadFavorites(),
                ),
              ],
              child: const RestaurantSearchView(),
            ),
          ),
        );
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
            hintText: "Search restaurants...",
            fillColor: AppColors.thirdColor,
            filled: true,
            border: border(),
            enabledBorder: border(),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );
  }
}
