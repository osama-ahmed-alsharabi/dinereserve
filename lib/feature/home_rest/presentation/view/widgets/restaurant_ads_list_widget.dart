import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/restaurant_ad_card_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_cubit.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantAdsListWidget extends StatelessWidget {
  const RestaurantAdsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeRestCubit, HomeRestState>(
      builder: (context, state) {
        if (state is HomeRestLoading) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeRestError) {
          return SizedBox(
            height: 220,
            child: Center(child: Text(state.message)),
          );
        } else if (state is HomeRestEmpty) {
          return _buildEmptyState();
        } else if (state is HomeRestLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Text(
                  "Your Advertisements",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.ads.length,
                  itemBuilder: (context, index) {
                    final ad = state.ads[index];
                    return RestaurantAdCardWidget(
                      ad: ad,
                      onDelete: () => _confirmDelete(context, ad),
                      onEdit: () => _showEditDialog(context, ad),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "No advertisements yet",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdvertisementModel ad) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Advertisement"),
        content: const Text("Are you sure you want to delete this ad?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HomeRestCubit>().deleteAd(ad.id!, ad.imageUrl);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, AdvertisementModel ad) async {
    // Use the earlier date between ad.startDate and now to avoid assertion error
    final firstDate = ad.startDate.isBefore(DateTime.now())
        ? ad.startDate
        : DateTime.now();

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(start: ad.startDate, end: ad.endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final updatedAd = AdvertisementModel(
        id: ad.id,
        restaurantId: ad.restaurantId,
        imageUrl: ad.imageUrl,
        startDate: picked.start,
        endDate: picked.end,
        createdAt: ad.createdAt,
      );
      // ignore: use_build_context_synchronously
      context.read<HomeRestCubit>().updateAd(updatedAd);
    }
  }
}
