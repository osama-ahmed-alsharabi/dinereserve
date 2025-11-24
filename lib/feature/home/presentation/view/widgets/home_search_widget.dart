import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
        hintText: "search..",
        fillColor: AppColors.thirdColor,
        filled: true,
        border: border(),
        enabledBorder: border(),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey),
    );
  }
}
