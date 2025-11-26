import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_state.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/profile_restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantCardWidget extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantCardWidget({super.key, required this.restaurant});

  bool _isRestaurantOpen() {
    try {
      final now = TimeOfDay.now();
      final open = _parseTime(restaurant.openingTime);
      final close = _parseTime(restaurant.closingTime);

      final nowMinutes = now.hour * 60 + now.minute;
      final openMinutes = open.hour * 60 + open.minute;
      final closeMinutes = close.hour * 60 + close.minute;

      if (closeMinutes < openMinutes) {
        // Overnight hours (e.g., 18:00 to 02:00)
        return nowMinutes >= openMinutes || nowMinutes <= closeMinutes;
      } else {
        // Standard hours (e.g., 09:00 to 22:00)
        return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
      }
    } catch (e) {
      return false; // Default to closed on error
    }
  }

  TimeOfDay _parseTime(String time) {
    try {
      // Handle 12-hour format (e.g., "12:52 PM")
      final parts = time.trim().split(' ');
      if (parts.length == 2) {
        final timeParts = parts[0].split(':');
        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final isPM = parts[1].toUpperCase() == 'PM';

          // Convert to 24-hour format
          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }

          return TimeOfDay(hour: hour, minute: minute);
        }
      }

      // Fallback: try 24-hour format
      final parts24 = time.split(':');
      if (parts24.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts24[0]),
          minute: int.parse(parts24[1]),
        );
      }
    } catch (e) {
      // Return midnight on error
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = _isRestaurantOpen();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileRestaurantView(
              isReadOnly: true,
              restaurantModel: restaurant,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: restaurant.logo != null
                        ? Image.network(
                            restaurant.logo!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final isFav = context.read<FavoritesCubit>().isFavorite(
                          restaurant.restaurantId!,
                        );
                        return GestureDetector(
                          onTap: () {
                            context.read<FavoritesCubit>().toggleFavorite(
                              restaurant,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(230),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(153),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        restaurant.restaurantType.isNotEmpty
                            ? restaurant.restaurantType
                            : "Restaurant",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.restaurantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              "4.8", // Placeholder
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              " (120+)",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isOpen
                                  ? [
                                      const Color(0xFF4CAF50),
                                      const Color(0xFF66BB6A),
                                    ]
                                  : [
                                      const Color(0xFFEF5350),
                                      const Color(0xFFE57373),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isOpen
                                    ? const Color(0xFF4CAF50).withAlpha(102)
                                    : const Color(0xFFEF5350).withAlpha(102),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withAlpha(128),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isOpen ? "Open" : "Closed",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
