import 'package:dinereserve/feature/home_rest/presentation/view/widgets/home_reset_app_bar_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/restaurant_ads_list_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/restaurant_dashboard_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_cubit.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRestViewBodyWidget extends StatelessWidget {
  const HomeRestViewBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<HomeRestCubit>().fetchAds();
          if (context.mounted) {
            final period = context.read<DashboardCubit>().currentPeriod;
            context.read<DashboardCubit>().changePeriod(period);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeRestAppBarWidget(),
              const SizedBox(height: 20),
              const RestaurantAdsListWidget(),
              const SizedBox(height: 24),
              // Dashboard Section
              const RestaurantDashboardWidget(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
