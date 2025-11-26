import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddAdvertisementSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddAdvertisementSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          shadowColor: AppColors.primaryColor.withOpacity(0.5),
        ),
        child: const Text(
          "Publish Advertisement",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
