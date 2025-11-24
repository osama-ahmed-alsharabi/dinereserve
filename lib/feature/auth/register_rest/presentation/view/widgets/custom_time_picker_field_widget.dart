import 'package:flutter/material.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';

class CustomTimePickerFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double? padding;

  const CustomTimePickerFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.padding,
  });

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final formatted = time.format(context);
      controller.text = formatted;
    }
  }

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
          GestureDetector(
            onTap: () => _pickTime(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                validator: validator,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
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
              ),
            ),
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
