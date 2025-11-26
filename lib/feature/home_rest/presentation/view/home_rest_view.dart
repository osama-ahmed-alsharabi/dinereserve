import 'package:dinereserve/feature/home_rest/presentation/view/widgets/home_reset_app_bar_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/restaurant_ads_list_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRestView extends StatelessWidget {
  const HomeRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeRestCubit()..fetchAds(),
      child: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeRestAppBarWidget(),
              SizedBox(height: 20),
              RestaurantAdsListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
