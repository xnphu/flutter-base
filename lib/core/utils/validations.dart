import 'dart:async';

import 'package:base/data/remote/api/index.dart';

final cardNumberRegex = r'^[0-9]{15,18}$';
final cvvRegex = r"^[0-9]{3,4}$";
final expiredDateRegex = r"^[0-9]{2}/[0-9]{4}$";
// final emailRegex = r"^[^.-]+[a-zA-Z0-9.-]+[^.-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
final emailRegex =
    r"^[a-zA-Z0-9]+([\-]?)+([\._]?[a-zA-Z0-9])+([\._(?!.*?\.\.)]?)@[^@][a-z0-9\-]{2,}(\.[a-z0-9]{2,4}){1,2}$";
// final phoneNumberRegex =
//     r"^[+]{1}[1-9]{2}([0-9]+){9,}$|^0([0-9]+){9,}$|^([+]{0,1}([0-9]+-[0-9]+)+[0-9]+$|^[+]{0,1}([0-9]+ [0-9]+)+[0-9]+){9,}$";
final userNameRegex = ".+"; //r"^[a-zA-Z0-9_\\-\\.]+$";
final passwordRegex =
    r'^[a-zA-Z0-9\u0027\|\{\}@#$%^&+=*.,\-_!`\[\]";:<>?/\\]+$';
final searchPhoneRegex = r"^[0-9\\s]+$";
final residentIdRegex = r"^[0-9]{8,12}$";
final idCardRegex = r"^[0-9]{9,12}$";
final bankAccountRegex = r"^[0-9]{8,15}$";
final userIdInputRegex = r"^[a-zA-Z0-9]*$";
final onlyNumbersRegex = r'[^\d]';
final phoneNumberRegex = r'^[0-9]+$';

// final emailRegister = r'^[a-zA-Z0-9]+([\-]?)+([\._]?[a-zA-Z0-9\-])+([\._]?)*([a-zA-Z0-9])@[a-zA-Z0-9\-]([\._]?[a-zA-Z0-9\-])*(\.\w{2,})+$';
final emailRegister =
    r'(?![a-zA-Z0-9._@-]*[.-]{2,}[a-zA-Z0-9._@-]*$)([a-zA-Z0-9._-]+)([a-zA-Z0-9]@[a-zA-Z0-9])([a-zA-Z0-9.-]+)([a-zA-Z0-9]\.[a-zA-Z]{2,3})+$';
final passwordRegister = r'^[a-zA-Z0-9@#$%^&+=*.\-_]{6,}$';

typedef ValidatorFunction = bool Function(String, String?);

const int MIN_LENGTH_PASSWORD = 6;
const int MAX_LENGTH_PASSWORD = 6;
const int MAX_LENGTH_NAME = 256;
const int MAX_LENGTH_KANA_NAME = 50;
const int MAX_LENGTH_OCCUPATION = 50;
const int VALID_LENGTH_ZIPCODE = 7;
const int MAX_LENGTH_ADDRESS = 100;
const int MAX_LENGTH_PHONE = 11;
const int MAX_LENGTH_EMAIL = 256;
const int MAX_LENGTH_SALON_NAME = 256;
const int MAX_LENGTH_ID_CARD = 12;

class Validators {
  static String validationImageUrl(String url) {
    return (url.startsWith('https')) ? url : '$IMAGE_BASE_URL$url';
  }

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    RegExp regex = new RegExp(passwordRegex);
    if (regex.hasMatch(password)) {
      sink.add(password);
    } else {
      sink.addError('Password error');
    }
  });

  static bool isPasswordValid(String inputPassword, String? text) {
    RegExp regex = new RegExp(passwordRegister);
    return regex.hasMatch(inputPassword);
  }

  static bool isPhoneNumberValid(String inputPhoneNumber, String? text) {
    RegExp regex = new RegExp(phoneNumberRegex);
    return regex.hasMatch(inputPhoneNumber);
  }

  static bool isEmailValid(String email, String? text) {
    RegExp regex = new RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  static bool isTheSameText(String password, String? passwordConfirm) {
    return password == passwordConfirm;
  }

  static bool isFullNameValid(String inputFullName, String? text) {
    return inputFullName.isNotEmpty;
  }

  static bool isIdCardValid(String idCard, String? text) {
    RegExp regex = new RegExp(idCardRegex);
    return regex.hasMatch(idCard);
  }
}
