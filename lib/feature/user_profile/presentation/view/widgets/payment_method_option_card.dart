import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodOptionCard extends StatelessWidget {
  final String id;
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodOptionCard({
    super.key,
    required this.id,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primaryColor, Color(0xFFFF8A65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColor.withAlpha(77)
                  : Colors.black.withAlpha(13),
              blurRadius: isSelected ? 20 : 10,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(51)
                    : AppColors.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            // Check Icon
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
