
import 'package:flutter/material.dart';

class ValidatorHelper {
  static String? validateRequired(
    String? value, {
    String? fieldName,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? 'الرجاء إدخال $fieldName' : '';
    }
    return null;
  }

  static String? validateEmail(String? value, {required BuildContext context}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "الايميل مطلوب";

    final emailRegex = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,24}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(v)) {
      return "الايميل غير صالح";
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return "الرجاء ادخال الباسورد";
    }
    if (value.length < 6) {
      return "يجب على الاقل ان تتكون كملة المرور من 6 احرف او ارقام";
    }
    return null;
  }

  static String? validatePhoneNumber(
    String? value, {
    required BuildContext context,
  }) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) {
      return "الرجاء ادخال رقم الهاتف";
    }

    final normalized = _toAsciiDigits(raw).replaceAll(RegExp(r'[\s-]'), '');

    final phoneRegex = RegExp(r'^(77|78|71|73|70)\d{7}$');

    if (!phoneRegex.hasMatch(normalized)) {
      return "يجب ان يكون 9 ارقام وان يبداء 77, 78 , 71 , 73 , 70";
    }
    return null;
  }

  static String _toAsciiDigits(String input) {
    final sb = StringBuffer();
    for (final cp in input.runes) {
      if (cp >= 0x0660 && cp <= 0x0669) {
        sb.write(cp - 0x0660);
      } else if (cp >= 0x06F0 && cp <= 0x06F9) {
        sb.write(cp - 0x06F0);
      } else {
        sb.write(String.fromCharCode(cp));
      }
    }
    return sb.toString();
  }
}