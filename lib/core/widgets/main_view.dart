import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/widgets/custom_nav_bar.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_body_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/data/get_restaurant_repo.dart';
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
    Center(child: Text("Booking")),
    Center(child: Text("Bot")),
    Center(child: Text("Favorite")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(GetRestaurantRepo(getIt.get<SupabaseClient>()))
            ..getAllRestaurants(),
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
    );
  }
}
