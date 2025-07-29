class Validation {
  static final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final password = RegExp(
      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=\[\]{};:',.<>?/\\|`~]).{8,}$");
  static final specialCharacter =
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\[\]\\\/`~+=;\-]');
  static final everyChar = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).+$');
  static final numbers = RegExp(r'\d+');
}
