import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/profile_restaurant_view.dart';
import 'package:flutter/material.dart';

class HomeAdBannerWidget extends StatelessWidget {
  final AdvertisementModel ad;

  const HomeAdBannerWidget({super.key, required this.ad});

  Future<void> _navigateToRestaurant(BuildContext context) async {
    try {
      // Fetch restaurant details in background
      final repo = getIt.get<GetRestaurantRepo>();
      final responseFuture = repo.supabase
          .from('restaurant')
          .select()
          .eq('restaurant_id', ad.restaurantId)
          .single();

      // Navigate immediately with a loading state
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Map<String, dynamic>>(
            future: responseFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load restaurant',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final restaurant = RestaurantModel.fromMap(snapshot.data!);
              return ProfileRestaurantView(
                isReadOnly: true,
                restaurantModel: restaurant,
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load restaurant: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToRestaurant(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(ad.imageUrl),
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
      ),
    );
  }
}
