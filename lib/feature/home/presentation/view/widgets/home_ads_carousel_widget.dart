import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_ad_banner_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_ads_cubit.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_ads_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAdsCarouselWidget extends StatefulWidget {
  const HomeAdsCarouselWidget({super.key});

  @override
  State<HomeAdsCarouselWidget> createState() => _HomeAdsCarouselWidgetState();
}

class _HomeAdsCarouselWidgetState extends State<HomeAdsCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAdsCubit, HomeAdsState>(
      builder: (context, state) {
        if (state is HomeAdsLoading) {
          return Container(
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeAdsLoaded) {
          return Column(
            children: [
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: state.ads.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return HomeAdBannerWidget(ad: state.ads[index]);
                  },
                ),
              ),
              if (state.ads.length > 1) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.ads.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? AppColors.primaryColor
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        } else if (state is HomeAdsEmpty || state is HomeAdsError) {
          // Fallback to default placeholder if no ads or error
          return Container(
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://img.freepik.com/free-vector/flat-design-food-banner-template_23-2149076251.jpg",
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
