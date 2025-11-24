import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTextFromFieldPassword extends StatefulWidget {
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? padding;
  const CustomTextFromFieldPassword({
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
  State<CustomTextFromFieldPassword> createState() =>
      _CustomTextFromFieldPasswordState();
}

class _CustomTextFromFieldPasswordState
    extends State<CustomTextFromFieldPassword> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              widget.label,
              style: context.textStyle.text16Regular.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          TextFormField(
            obscureText: showPassword,
            validator: widget.validator,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: AppColors.primaryColor,
              filled: true,

              enabledBorder: textBorder(),
              focusedBorder: textBorder(),
              focusedErrorBorder: textBorder(),
              errorBorder: textBorder(),
              hintText: widget.hint,
              hintStyle: context.textStyle.text12Regular.copyWith(
                color: Colors.white,
              ),
              prefixIcon: Icon(widget.icon, color: Colors.white),
              suffixIcon: IconButton(
                onPressed: () {
                  showPassword = !showPassword;
                  setState(() {});
                },
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              ),
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
