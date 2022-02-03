import 'package:validators/validators.dart';

class SignUpValidator {
  static String? _pass;

  static String? nameValidator(String? name) {
    if (isNull(name) || name!.isEmpty)
      return "Please enter your name";
    else if (!isAscii(name)) return "Invalid name";
    return null;
  }

  static String? emailValidator(String? email) {
    if (isNull(email) || email!.isEmpty)
      return "Please enter your email";
    else if (!isEmail(email)) return "Invalid email";
    return null;
  }

  static String? passwordValidator(String? password) {
    _pass = password;
    if (isNull(password) || password!.isEmpty)
      return "Please enter your password";
    else if (!isAscii(password))
      return "Invalid password";
    else if (password.length > 15)
      return "Password is too long";
    else if (password.length < 8) return "Password is too short";
    return null;
  }

  static String? confirmValidator(String? confirm) {
    if (confirm != _pass) return "don't match password";
  }

  static String? numberValidator(String? number) {
    if (isNull(number) || number!.isEmpty)
      return "Please enter your number";
    else if (!isNumeric(number) ||
        number.length != 10 ||
        number.substring(0, 2) != "09") return "Invalid number";
    return null;
  }
}
