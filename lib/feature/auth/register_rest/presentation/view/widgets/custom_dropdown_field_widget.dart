import 'package:flutter/material.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';

class CustomDropdownFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final double? padding;

  const CustomDropdownFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
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
            child: Text(label, style: context.textStyle.text16Regular),
          ),
          DropdownButtonFormField<String>(
            value: value,
            validator: validator,
            dropdownColor: AppColors.primaryColor,
            style: context.textStyle.text16Regular.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              fillColor: AppColors.primaryColor,
              filled: true,
              enabledBorder: _border(),
              focusedBorder: _border(),
              errorBorder: _border(),
              focusedErrorBorder: _border(),
              hintText: hint,
              hintStyle: context.textStyle.text12Regular.copyWith(
                color: Colors.white,
              ),
              prefixIcon: Icon(icon, color: Colors.white),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            onChanged: onChanged,
            items: items
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(color: Colors.white),
    );
  }
}
