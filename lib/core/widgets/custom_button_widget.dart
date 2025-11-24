import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const CustomButtonWidget({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
