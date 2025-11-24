class SupabaseErrorHandler {
  static String parseAuthException(dynamic e) {
    final error = e.toString();

    // User already exists
    if (error.contains("user_already_exists") ||
        error.contains("User already registered")) {
      return "This phone number is already registered.";
    }

    // Invalid login credentials
    if (error.contains("Invalid login credentials")) {
      return "Incorrect phone number or password.";
    }

    // Email invalid
    if (error.contains("email_address_invalid")) {
      return "Internal error: Generated email is invalid.";
    }

    // Password too weak
    if (error.contains("Password should be at least")) {
      return "Password is too weak.";
    }

    // Rate limit
    if (error.contains("rate_limit")) {
      return "Too many attempts. Please try again later.";
    }

    // Default
    return "Something went wrong. Please try again.";
  }

  static String parseDatabaseException(dynamic e) {
    final error = e.toString();

    // RLS error
    if (error.contains("row-level security")) {
      return "Permission denied when saving user profile.";
    }

    // Duplicate row or primary key
    if (error.contains("duplicate key")) {
      return "Profile already exists.";
    }

    return "Database error occurred.";
  }
}
