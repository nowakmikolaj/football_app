import 'package:email_validator/email_validator.dart';
import 'package:football_app/utils/resources.dart';

const passwordLength = 6;

class Validation {
  static String? validateEmail(String? email) {
    return email != null && !EmailValidator.validate(email)
        ? Resources.emailValidationError
        : null;
  }

  static String? validatePassword(String? password) {
    return password != null && password.length < passwordLength
        ? Resources.passwordValidationError
        : null;
  }

  static String? validateBet(String? text) {
    return text != null && text.isEmpty ? "" : null;
  }
}
