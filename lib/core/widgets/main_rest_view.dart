import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/widgets/custom_nav_bar_rest_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/home_rest_view.dart';
import 'package:dinereserve/feature/profile_restaurant/data/get_restaurant_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/profile_restaurant_view.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainRestView extends StatefulWidget {
  const MainRestView({super.key});

  @override
  State<MainRestView> createState() => _MainRestViewState();
}

class _MainRestViewState extends State<MainRestView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeRestView(),
    Center(child: Text("Booking")),
    ProfileRestaurantView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetRestaurantCubit(GetRestaurantRepo(getIt.get<SupabaseClient>()))
            ..fetchRestaurant(),
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: CustomNavBarRestWidget(
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
