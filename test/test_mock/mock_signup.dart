import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/validation.dart';

class MockSignup {
  String? validateEmail(String email, String error) {
    if (email.isEmpty) {
      return "Email cannot be empty";
    }
    if (!Validation.emailValid.hasMatch(email)) {
      return error;
    }
    return null;
  }

  String? validatePassword(String password, String error) {
    if (password.isEmpty) {
      return "Password cannot be empty";
    }
    if (!(Validation.everyChar.hasMatch(password) &&
        password.trim().length >= 8 &&
        password.trim().length <= AppConst.TEXTFIELD_DEFAULT_LENGTH)) {
      return error;
    }
    return null;
  }

  Future<bool> login(String email, String password, String emailError,
      String passwordError) async {
    if (validateEmail(email, emailError) != null ||
        validatePassword(password, passwordError) != null) {
      return false;
    }
    return true;
  }
}
