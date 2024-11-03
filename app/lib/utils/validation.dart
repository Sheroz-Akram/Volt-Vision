class Validation {
  // Validate email
  String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Invalid email address";
    }
    return null;
  }

  // Validate name (at least 3 characters, at most 30 characters)
  String? validateName(String name) {
    if (name.length < 3) {
      return "Name must be at least 3 characters long";
    }
    if (name.length > 30) {
      return "Name must be at most 30 characters long";
    }
    return null;
  }

  // Validate password (at least 6 characters, 1 lowercase, 1 uppercase, and 1 special character)
  String? validatePassword(String password) {
    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      return "Password must contain at least one special character";
    }
    return null;
  }
}
