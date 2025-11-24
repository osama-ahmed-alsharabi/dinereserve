import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "good night",
              style: context.textStyle.text28Mediam.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            Text("Name", style: context.textStyle.text16Regular),
          ],
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
            border: Border.all(
              color: Colors.white
            )
          ),
          child: SvgPicture.asset(AppAsset.imagesNotifications, height: 25),
        ),
      ],
    );
  }
}
