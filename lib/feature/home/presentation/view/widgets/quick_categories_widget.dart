import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class QuickCategoriesWidget extends StatelessWidget {
  const QuickCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Quick categories",
          style: context.textStyle.text20Mediam.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 10,),
        
      ],
    );
  }
}
