import 'package:dinereserve/feature/home/presentation/view/widgets/featured_restaurants_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_ads_carousel_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_app_bar_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_search_widget.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/quick_categories_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_ads_cubit.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeAdsCubit()..fetchActiveAds(),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeAdsCubit>().fetchActiveAds();
                if (context.mounted) {
                  await context.read<HomeCubit>().getAllRestaurants();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HomeAppBarWidget(),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HomeSearchWidget(),
                    ),
                    const SizedBox(height: 24),
                    const QuickCategoriesWidget(),
                    const SizedBox(height: 24),
                    // Ads Carousel
                    const HomeAdsCarouselWidget(),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: FeaturedRestaurantsWidget(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
