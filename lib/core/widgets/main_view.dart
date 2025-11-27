import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/widgets/custom_nav_bar.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/favorites/presentation/view/favorites_view.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_body_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/booking/presentation/view/user_bookings_view.dart';
import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/user_profile_view.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeBodyWidget(),
    UserBookingsView(),
    Center(child: Text("Bot")),
    FavoritesView(),
    UserProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(getIt.get<UserProfileRepo>()),
      child: BlocProvider(
        create: (context) =>
            HomeCubit(GetRestaurantRepo(getIt.get<SupabaseClient>()))
              ..getAllRestaurants(),
        child: BlocProvider(
          create: (context) =>
              FavoritesCubit(getIt.get<FavoritesRepo>())..loadFavorites(),
          child: Scaffold(
            body: IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
