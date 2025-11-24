class ValidatorHelper {
  /// Required field
  static String? validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    }
    return null;
  }

  /// Full Name (only letters, at least 3 chars)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }

    if (value.trim().length < 3) {
      return "Full name must be at least 3 characters";
    }

    return null;
  }

  /// Saudi Phone Number - 05XXXXXXXX
  static String? validateSaudiPhone(String? value) {
    final v = value?.trim() ?? "";

    if (v.isEmpty) return "Please enter your phone number";

    final cleaned = v.replaceAll(RegExp(r'[\s-]'), '');

    final phoneRegex = RegExp(r'^05\d{8}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return "Phone number must start with 05 and be 10 digits";
    }

    return null;
  }

  /// Age validation
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your age";
    }

    final age = int.tryParse(value.trim());

    if (age == null) {
      return "Age must be a valid number";
    }

    if (age < 10 || age > 120) {
      return "Age must be between 10 and 120";
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  /// Confirm password
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != originalPassword) {
      return "Passwords do not match";
    }

    return null;
  }
}
