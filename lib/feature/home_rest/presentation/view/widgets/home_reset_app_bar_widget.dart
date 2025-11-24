import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeRestAppBarWidget extends StatelessWidget {
  const HomeRestAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          RestaurantLocalService().getRestaurant()!.restaurantName,
          style: context.textStyle.text28Bold.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.thirdColor,
            border: Border.all(color: Colors.white),
          ),
          child: SvgPicture.asset(AppAsset.imagesNotifications, height: 25),
        ),
      ],
    );
  }
}
