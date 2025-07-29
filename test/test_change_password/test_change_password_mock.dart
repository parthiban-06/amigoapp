class MockConfirmPassword {
  String? validatePassword(String value, String? errorMessage) {
    if (value.isEmpty) return errorMessage ?? "Password cannot be empty";
    if (value.length < 6)
      return errorMessage ?? "Password must be at least 6 characters";
    return null;
  }

  String? validateConfirmPassword(String newPassword, String confirmPassword) {
    if (newPassword != confirmPassword) return "Passwords do not match";
    return null;
  }
}
