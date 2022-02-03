import 'package:validators/validators.dart';

class LogInValidator {
  static String? emailValidator(String? email) {
    if (isNull(email) || email!.isEmpty)
      return "Please enter your email";
    else if (!isEmail(email)) return "Invalid Email";
    return null;
  }

  static String? passwrodValidator(String? password) {
    if (isNull(password) || password!.isEmpty)
      return "Please enter your password";
    else if (!isAscii(password)) return "Invalid password";
    return null;
  }
}
