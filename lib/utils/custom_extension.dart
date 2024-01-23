// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/user_model.dart';
import '/utils/custom_enum.dart';
import '../constants/img_font_color_string.dart';

//String Extension...
extension StringExtension on String {
  bool get isImage =>
      toLowerCase().endsWith(".jpg") ||
      toLowerCase().endsWith(".jpeg") ||
      toLowerCase().endsWith(".png") ||
      toLowerCase().endsWith(".gif") ||
      toLowerCase().endsWith(".webp") ||
      toLowerCase().endsWith(".heic");

  // Remove Special character from string...
  String get removeSpecialCharacters =>
      trim().replaceAll(RegExp(r'[^A-Za-z0-9]'), '');

  // Process String...
  List<TextSpan> processCaption({
    String matcher = "#",
    TextStyle? fancyTextStyle,
    TextStyle? normalTextStyle,
    void Function(String)? onTap,
  }) {
    return split(' ')
        .map(
          (text) => TextSpan(
            text: (text.toString().contains(matcher)
                    ? text.replaceAll(matcher, "")
                    : text) +
                ' ',
            style: text.toString().contains(matcher)
                ? fancyTextStyle
                : normalTextStyle,
            recognizer: text.toString().contains(matcher)
                ? onTap == null
                    ? null
                    : (TapGestureRecognizer()..onTap = () => onTap(text))
                : null,
          ),
        )
        .toList();
  }

  //Change time format to 24 hr...
  String to24hrFormat() {
    try {
      debugPrint(this);
      DateTime dt = DateFormat("hh:mm a").parse(this).toLocal();
      
      return DateFormat("HH:mm:ss").format(dt);
    } catch (e) {
      debugPrint(
          "Error while converting 24hr time format, please check incomming time is $this");
      return "";
    }
  }

  String toDateFormat(
      {String incommingDateFormate = "yyyy-MM-dd HH:mm:ss",
      String requiredFormat = "MM/dd/yyyy hh:mm a",
      bool needToConvertToLocal = false}) {
    //! if date need to convert in to local. Date must requires in this formate(eg. "2021-01-01 00:00:00.000z")

    if (isEmpty) return this;

    DateFormat dateFormat = DateFormat(incommingDateFormate);

    try {
      // if (needToConvertToLocal) {
      //   return DateFormat(requiredFormat)
      //       .format(DateTime.parse(this + "z").toLocal());
      // } else {
      return DateFormat(requiredFormat)
          .format(dateFormat.parse(toString()).toLocal());
      // }
    } catch (error) {
      debugPrint(
          "Please check incomming date format, format should be $incommingDateFormate:- $error");
      return this;
    }
  }

  String get toFirstLetter {
    if (isEmpty) return this;
    String temp = "";
    List<String> splittedWords = isEmpty ? [] : split(" ");

    splittedWords.removeWhere((word) => word.isEmpty);

    if (splittedWords.length == 1) {
      temp = splittedWords[0][0].removeSpecialCharacters.toUpperCase();
    } else if (splittedWords.length >= 2) {
      temp = splittedWords[0][0].removeSpecialCharacters.toUpperCase() +
          splittedWords[1][0].removeSpecialCharacters.toUpperCase();
    }

    return temp;
  }

  String get toCapitalFirstLetter {
    return isEmpty ? "" : toFirstLetter.toUpperCase() + substring(1, length);
  }

  //Change time format to 12 hr...
  String get to12hrFormat {
    try {
      DateTime dt = DateFormat("HH:mm").parse(this);
      return DateFormat("hh:mm a").format(dt);
    } catch (e) {
      debugPrint(
          "Error while converting 12hr time format, please check incomming time is $this");
      return "";
    }
  }

  //Change time format to 12 hr...
  String get to12hrFormatWithDate {
    try {
      DateTime dt = DateFormat("MM/dd/yyyy HH:mm:ss").parse(this);
      return DateFormat("MM/dd/yyyy hh:mma").format(dt);
    } catch (e) {
      debugPrint(
          "Error while converting 12hr time format, please check incomming time is $this");
      return "";
    }
  }

  // Check route is same route, if its same return empty...
  String getRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.name == this ? "" : this;
  }

  /// price formate  (₹00,000.00)
  static NumberFormat priceFormat =
      NumberFormat.currency(customPattern: '#,###', decimalDigits: 2);

  String get priceFormater {
    String price = priceFormat.format(double?.tryParse(this) ?? 0.0);
    price = price.split(".").first.isEmpty ? "0$price" : price;
    return price;
  }

  static NumberFormat rateFormat =
      NumberFormat.currency(customPattern: '#,### ', decimalDigits: 0);

  String get rateFormater {
    return rateFormat.format(double?.tryParse(this) ?? 0.0);
  }

  static NumberFormat rateFormatWithDecimal2 =
      NumberFormat.currency(customPattern: '#,### ', decimalDigits: 2);

  String get rateFormaterWithDecimal2 {
    return rateFormatWithDecimal2.format(double?.tryParse(this) ?? 0.0);
  }

  //Email validation Regular expression...
  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static final ssnRegExp = RegExp(r'^\d{3}-?\d{2}-?\d{4}$');

  String? get firstName => trim().split(' ').first.toCapitalFirstLetter;

  //Validate Name...
  String? get validateName =>
      trim().isEmpty ? AlertMessageString.emptyName : null;

  //Validate Email...
  String? get validateEmail => trim().isEmpty
      ? AlertMessageString.emptyEmail
      : !RegExp(emailRegx).hasMatch(trim())
          ? AlertMessageString.validEmail
          : null;

  // Validate Review
  String? get validateReview => trim().isEmpty
      ? AlertMessageString.emptyReview
      : trim().length < 10
          ? AlertMessageString.shortReview
          : null;

// Validate Password...
  String? get validatePassword => trim().isEmpty
      ? AlertMessageString.emptyPwd
      : trim().length < 8
          ? AlertMessageString.validPassword
          : null;

  //Validate More Info   ...
  String? get validateMoreInfo =>
      trim().isEmpty ? AlertMessageString.emptyMoreInfo : null;

  //Validate Address   ...
  String? get validateAddress =>
      trim().isEmpty ? AlertMessageString.emptyAddress : null;

  //!--------------  Verify Identity Background Check Validation ---------

  //Validate First Name
  String? get validateFirstName =>
      trim().isEmpty ? AlertMessageString.emptyFirstName : null;

  //Validate Last Name
  String? get validateLastName =>
      trim().isEmpty ? AlertMessageString.emptyLastName : null;

  //Validate dob
  //String? get validateDob =>
  //  trim().isEmpty ? AlertMessageString.emptyDob : null;

  //Validate ssn
  // String? get validateSsn => trim().isEmpty
  //     ? AlertMessageString.emptySsn
  //     : !ssnRegExp.hasMatch(this)
  //         ? AlertMessageString.invalidSSN
  //         : null;

  //Validate First Name
  String? get validateZipCode =>
      trim().isEmpty ? AlertMessageString.emptyZipCode : null;

  //!--------------  Lend New items validation----------------------
  //Validate Item Name...
  String? get validateItemName =>
      trim().isEmpty ? AlertMessageString.emptyItemName : null;

  //Validate Lender Type...
  String? get validateLenderType =>
      trim().isEmpty ? AlertMessageString.emptyLenderType : null;

  //Validate Category Type...
  String? get validateCategoryType =>
      trim().isEmpty ? AlertMessageString.emptyCategoryType : null;

  //Validate exchange pref...
  String? get validateExchangePref =>
      trim().isEmpty ? AlertMessageString.emptyExchangePref : null;

  //Validate return pref...
  String? get validateReturnPref =>
      trim().isEmpty ? AlertMessageString.emptyReturnPref : null;

  //Validate location...
  String? get validatelocation =>
      trim().isEmpty ? AlertMessageString.emptylocation : null;

//Validate Description...
  String? get validateDescription =>
      trim().isEmpty ? AlertMessageString.emptyDescription : null;

  //Validate Value...
  String? get validateValue => trim().isEmpty
      ? AlertMessageString.emptyValue
      : double.parse(this) <= 0
          ? "Value must be grater than 0"
          : double.parse(this) > 5000
              ? "Value must not be greater than 5000"
              : null;

  //Validate Duration...
  String? get validateDuration => trim().isEmpty
      ? AlertMessageString.emptyDuration
      : int.parse(trim()) <= 0
          ? AlertMessageString.invalidDuration
          : null;

  //Validate Safety Deposite...
  String? get validateSafetyDeposite =>
      trim().isEmpty ? AlertMessageString.emptySafetyDeposite : null;

  //Validate Rate Per Day...
  String? get validateRatePerDay => trim().isEmpty
      ? AlertMessageString.emptyRatePerDay
      : double.tryParse(trim()) == null
          ? AlertMessageString.invalidRate
          : null;

  String? get validateMaxHours =>
      trim().isEmpty ? AlertMessageString.maxHour : null;

  //Validate Rate Per Day...
  String? get validateRatePerWeek =>
      trim().isEmpty ? AlertMessageString.emptyRatePerWeek : null;

  //Validate Rate Per Day...
  String? get validateRatePerMonth =>
      trim().isEmpty ? AlertMessageString.emptyRatePerMonth : null;

  static const String instahandelRegx =
      "^(?!.*\.\.)(?!.*\.\$)[^\W][\w.]{0,29}\$";

  static const String phoneNoRegx = "^[0-9]";

  bool isNullorEmpty(dynamic object) =>
      object == null || (object?.isEmpty ?? false);

  //Decode JWT Token...
  Map<String, dynamic> get getJsonFromJWT {
    try {
      if (isEmpty) {
        return {"exp": "0"};
      } else {
        String normalizedSource = base64Url.normalize(split(".")[1]);
        return json.decode(
          utf8.decode(
            base64Url.decode(normalizedSource),
          ),
        );
      }
    } catch (error) {
      debugPrint("Error converting token data, $error");
      return {"exp": "0"};
    }
  }

  String get currencyFormatter {
    // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
    double value = double.parse(this);

    if (value < 1000000) {
      // less than a million
      return value.toStringAsFixed(0);
    } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
      // less than 100 million
      double result = value / 1000000;
      return result.toStringAsFixed(2) + "M";
    } else if (value >= (1000000 * 10 * 100) &&
        value < (1000000 * 10 * 100 * 100)) {
      // less than 100 billion
      double result = value / (1000000 * 10 * 100);
      return result.toStringAsFixed(2) + "B";
    } else if (value >= (1000000 * 10 * 100 * 100) &&
        value < (1000000 * 10 * 100 * 100 * 100)) {
      // less than 100 trillion
      double result = value / (1000000 * 10 * 100 * 100);
      return result.toStringAsFixed(2) + "T";
    }

    return value.toString();
  }
}

//Convert Date...
extension DateConversion on DateTime {
  // To Server Date...
  DateTime get toUTCTimeZone =>
      DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(this));

  DateTime get toUTCTimeZoneWithT =>
      DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ss').format(this));

  // To Filter Date...
  String get tofilterDate => DateFormat('yyyy-MM-dd').format(this).toString();

  // To Filter Date...
  String get tofilterPlaceHolderDate => DateFormat('MM/dd/yyyy').format(this);
}

extension ExtEnum on Object {
  String get getEnumName => toString().split(".").last.toLowerCase();
}

bool isNullorEmpty(dynamic object) =>
    object == null || (object?.isEmpty ?? false);

// Check Double...
double checkAndToDouble(dynamic value) {
  return value == null ? 0.0 : double.tryParse(value.toString())!;
}

extension IntExtension on int {
//Epoch time to Local...
  String get epochToLocal {
    try {
      DateTime localTime =
          DateTime.fromMillisecondsSinceEpoch(this, isUtc: false);
      String dateTime =
          DateFormat("MM/dd/yyyy HH:mm:ss").format(localTime).toString();
      return dateTime.to12hrFormatWithDate;
    } catch (e) {
      return "";
    }
  }
}

//Get File name...
extension FileExtention on File {
  String get name {
    return path.split("/").last;
  }

  Future<int> get fileSize async {
    return length();
  }

  String get getFileSizeInMb {
    try {
      // Get length of file in bytes
      int fileSizeInBytes = lengthSync();

      // Convert the bytes to Kilobytes (1 KB = 1024 Bytes)
      double fileSizeInKB = fileSizeInBytes / 1024;

      // Convert the KB to MegaBytes (1 MB = 1024 KBytes)
      double fileSizeInMB = fileSizeInKB / 1024;

      return fileSizeInMB.toStringAsFixed(2);
    } catch (e) {
      return "0.0";
    }
  }
}

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color get hexToColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    try {
      final date = this;
      if (date != null) {
        final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
        final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
        return isAfter && isBefore;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

extension UserToUserInfo on User? {
  UserInfoModel get toUserInfoModel => UserInfoModel(
        id: this?.uid ?? "",
        authType: AuthType.None,
        email: this?.email ?? "",
        name: this?.displayName ?? "",
        // phoneNumber: this?.phoneNumber ?? "",
      );
}
