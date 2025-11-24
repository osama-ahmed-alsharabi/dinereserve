import 'package:flutter/material.dart';

class ProfileRestaurantFeatures extends StatelessWidget {
  final List<String> features;
  const ProfileRestaurantFeatures({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Features",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (features.isEmpty)
            const Text("No features added yet"),
          ...features.map((feature) => Text("• $feature")),
        ],
      ),
    );
  }
}
