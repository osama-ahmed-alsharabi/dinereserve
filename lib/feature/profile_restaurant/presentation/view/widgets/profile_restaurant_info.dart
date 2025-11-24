import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProfileRestaurantInfo extends StatelessWidget {
  final RestaurantModel restaurant;
  const ProfileRestaurantInfo({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            restaurant.restaurantName,
            style: context.textStyle.text28Bold.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 6),
              Text(restaurant.location),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.green),
              SizedBox(width: 6),
              Text(
                "Opening Time : ${restaurant.openingTime}",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timelapse, color: Colors.green),
              SizedBox(width: 6),
              Text(
                "Closing Time : ${restaurant.closingTime}",
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.phone, color: Colors.blue),
              SizedBox(width: 6),
              Text(restaurant.restaurantPhone),
            ],
          ),
        ],
      ),
    );
  }
}
