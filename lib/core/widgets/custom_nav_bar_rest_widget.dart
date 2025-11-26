import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomNavBarRestWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBarRestWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withAlpha(150),
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.home, "Home", 0),
          _buildItem(Icons.book, "Bookings", 1),
          _buildItem(Icons.person, "Profile", 2),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, int index) {
    final bool selected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Icon(
              icon,
              size: selected ? 26 : 24,
              color: selected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? AppColors.primaryColor : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
