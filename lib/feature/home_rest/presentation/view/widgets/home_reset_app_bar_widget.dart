import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dinereserve/core/helpers/service_locator.dart';

class HomeRestAppBarWidget extends StatelessWidget {
  const HomeRestAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          getIt<RestaurantLocalService>().getRestaurant()!.restaurantName,
          style: context.textStyle.text28Bold.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            context.pushNamed(AppRouterConst.addAdvertisementViewRouteName);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.thirdColor,
              border: Border.all(color: Colors.white),
            ),
            child: Icon(Icons.add, size: 30),
          ),
        ),
      ],
    );
  }
}
