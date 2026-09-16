class Validators {
  Validators._();

  // Empty check
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  // Email or Phone (Login / Register)
  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or Phone is required';
    }

    final text = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');

    if (emailRegex.hasMatch(text) || phoneRegex.hasMatch(text)) {
      return null;
    }
    return 'Enter valid email or phone number';
  }

  // Email only
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password (Login - simple)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // Strong password (Register / Reset - UI rules)
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'At least 8 characters required';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'One uppercase letter required';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'One number required';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'One special character required';
    }
    return null;
  }

  // Confirm password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Full name
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Enter a valid name';
    }
    return null;
  }

  // Password rules checklist (Reset Password UI)
  static bool hasMinLength(String value) => value.length >= 8;
  static bool hasUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);
  static bool hasNumber(String value) => RegExp(r'[0-9]').hasMatch(value);
  static bool hasSpecialChar(String value) =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
}
