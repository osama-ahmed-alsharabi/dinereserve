import 'package:flutter/material.dart';

class ProfileRestaurantFood extends StatelessWidget {
  final List<String> menu;
  const ProfileRestaurantFood({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Menu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (menu.isEmpty) const Text("No menu items added yet"),
          ...menu.map((item) => Text("• $item")),
        ],
      ),
    );
  }
}
