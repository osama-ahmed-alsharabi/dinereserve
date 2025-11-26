import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/category_restaurant_view_body_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/category_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRestaurantsView extends StatelessWidget {
  final String categoryName;

  const CategoryRestaurantsView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CategoryCubit(GetRestaurantRepo(getIt.get<SupabaseClient>()))
                ..getRestaurantsByType(categoryName),
        ),
        BlocProvider(
          create: (context) =>
              FavoritesCubit(getIt.get<FavoritesRepo>())..loadFavorites(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: CategoryRestaurantViewBodyWidget(categoryName: categoryName),
      ),
    );
  }
}
