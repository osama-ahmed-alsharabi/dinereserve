import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTextFromFieldWidget extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? padding;
  const CustomTextFromFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.controller,
    this.validator,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              label,
              style: context.textStyle.text16Regular.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          TextFormField(
            validator: validator,
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: AppColors.primaryColor,
              filled: true,

              enabledBorder: textBorder(),
              focusedBorder: textBorder(),
              focusedErrorBorder: textBorder(),
              errorBorder: textBorder(),
              hintText: hint,
              hintStyle: context.textStyle.text12Regular.copyWith(
                color: Colors.white,
              ),
              prefixIcon: Icon(icon, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder textBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: Colors.white),
    );
  }
}
