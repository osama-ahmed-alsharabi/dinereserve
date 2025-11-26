import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodHeader extends StatelessWidget {
  const PaymentMethodHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle Bar
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.payment_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        // Title
        const Text(
          "Payment Methods",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          "Choose your preferred payment method",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
