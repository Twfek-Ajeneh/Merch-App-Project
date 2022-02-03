import 'package:validators/validators.dart';

class AddProductValidator {
  static String? nameValidator(String? name) {
    if (isNull(name) || name!.isEmpty)
      return "Please enter product name";
    else if (!isAscii(name)) return "Invalid name";
    return null;
  }

  static String? typeValidator(String? type) {
    if (isNull(type) || type!.isEmpty)
      return "Please enter category";
    else if (!isAscii(type)) return "Invalid category";
    return null;
  }

  static String? priceValidator(String? price) {
    if (isNull(price) || price!.isEmpty)
      return "Please enter price";
    else if (double.parse(price) < 0 || !isFloat(price)) return "Invalid price";
    return null;
  }

  static String? countValidator(String? count) {
    if (isNull(count) || count!.isEmpty)
      return "Please enter count";
    else if (!isNumeric(count) || int.parse(count) < 0) return "Invalid number";
    return null;
  }

  static String? dateValidator(String? date) {
    if (isNull(date) || date!.isEmpty)
      return "Please enter expires date";
    else
      return null;
  }

  //for discount 1 and 2
  static String? discountValidator(String? discount) {
    if (isNull(discount) || discount!.isEmpty)
      return "Please enter discount";
    else if (!isFloat(discount) ||
        double.parse(discount) > 100 ||
        double.parse(discount) < 0) return "Invalid discount";
    return null;
  }

  //for days in discount 1 and 2
  static String? daysValidator(String? days) {
    if (isNull(days) || days!.isEmpty)
      return "Please enter days";
    else if (!isNumeric(days) || int.parse(days) < 0) return "Invalid number";
    return null;
  }

  static String? contactValidator(String? contact) {
    if (isNull(contact) || contact!.isEmpty)
      return "Please enter your contact info";
    bool m = false;
    if (isEmail(contact)) m = true;
    if (isNumeric(contact) ||
        contact.length == 10 ||
        contact.substring(0, 2) == "09") m = true;
    if (!m)
      return "Invalid info";
    else
      return null;
  }

  static String? descriptionValidator(String? description) {
    if (isNull(description) || description!.isEmpty) 
      return "Please enter description";
    return null;
  }
}
