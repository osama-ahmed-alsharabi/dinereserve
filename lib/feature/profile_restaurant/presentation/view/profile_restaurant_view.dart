import 'dart:ui';
import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_cubit.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/profile_restaurant_features.dart';
import 'widgets/profile_restaurant_edit_button.dart';
import 'widgets/profile_restaurant_food.dart';

class ProfileRestaurantView extends StatelessWidget {
  final bool isReadOnly;
  final RestaurantModel? restaurantModel;

  const ProfileRestaurantView({
    super.key,
    this.isReadOnly = false,
    this.restaurantModel,
  });

  @override
  Widget build(BuildContext context) {
    if (isReadOnly && restaurantModel != null) {
      return _buildContent(context, restaurantModel!);
    }

    return BlocBuilder<GetRestaurantCubit, GetRestaurantState>(
      builder: (context, state) {
        if (state is GetRestaurantSuccess) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<GetRestaurantCubit>().fetchRestaurant(),
            child: _buildContent(context, state.restaurant),
          );
        } else if (state is GetRestaurantFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, RestaurantModel restaurant) {
    final isOpen = _isRestaurantOpen(
      restaurant.openingTime,
      restaurant.closingTime,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Immersive Hero Image (Fixed Background)
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: restaurant.logo != null
                ? Image.network(restaurant.logo!, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.restaurant,
                      size: 100,
                      color: Colors.white24,
                    ),
                  ),
          ),

          // 2. Gradient Overlay for Text Visibility
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(77),
                    Colors.transparent,
                    Colors.black.withAlpha(204),
                  ],
                ),
              ),
            ),
          ),

          // 3. Custom App Bar Actions
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (getIt<UserLocalService>().getUser() != null || isReadOnly)
                  _buildGlassIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  )
                else
                  const SizedBox(),
                _buildGlassIconButton(
                  icon: Icons.share,
                  onTap: () {}, // Share logic
                ),
              ],
            ),
          ),

          // 4. Scrollable Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle Bar
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.restaurantType
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          restaurant.restaurantName,
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                restaurant.location,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Rating Box
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Column(
                                      children: [
                                        Text(
                                          "4.8",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "★",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Status & Hours
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isOpen
                                      ? Colors.green.withAlpha(13)
                                      : Colors.red.withAlpha(13),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isOpen
                                        ? Colors.green.withAlpha(51)
                                        : Colors.red.withAlpha(51),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: isOpen
                                                ? Colors.green.withAlpha(102)
                                                : Colors.red.withAlpha(102),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isOpen ? "Open Now" : "Closed",
                                      style: TextStyle(
                                        color: isOpen
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${restaurant.openingTime} - ${restaurant.closingTime}",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Gallery
                              if (restaurant.images.isNotEmpty) ...[
                                _buildSectionTitle("Gallery"),
                                const SizedBox(height: 16),
                                _buildGallery(restaurant.images),
                                const SizedBox(height: 32),
                              ],

                              // Amenities
                              _buildSectionTitle("Amenities"),
                              const SizedBox(height: 16),
                              ProfileRestaurantFeatures(
                                features: restaurant.features,
                              ),

                              const SizedBox(height: 32),

                              // Menu
                              _buildSectionTitle("Menu Highlights"),
                              const SizedBox(height: 16),
                              ProfileRestaurantFood(menu: restaurant.menu),

                              const SizedBox(height: 120), // Space for FAB
                            ],
                          ),
                        ),

                        if (!isReadOnly)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              children: [
                                const ProfileRestaurantEditButton(),
                                const SizedBox(height: 20),
                                TextButton.icon(
                                  onPressed: () async {
                                    await getIt
                                        .get<RestaurantLocalService>()
                                        .logout();
                                    if (context.mounted) {
                                      context.goNamed(
                                        AppRouterConst.loginViewRouteName,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // 5. Floating Action Button
          if (isReadOnly)
            Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withAlpha(102),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Booking feature coming soon!"),
                        backgroundColor: AppColors.primaryColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Book a Table",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(51)),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildGallery(List<String> images) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              images[index],
              width: 240,
              height: 180,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  bool _isRestaurantOpen(String openTime, String closeTime) {
    try {
      // Simple parsing assuming "HH:mm" format
      final now = TimeOfDay.now();
      final open = _parseTime(openTime);
      final close = _parseTime(closeTime);
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
}
