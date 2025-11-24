import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

abstract class CustomSnackBar {
  static customSnackBar({
    required BuildContext context,
    Color? color,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        backgroundColor: color,
        content: Text(title, style: context.textStyle.text16Regular),
      ),
    );
  }
}
