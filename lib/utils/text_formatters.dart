import 'package:flutter/services.dart';

class SSNTextInputFormatter extends TextInputFormatter {
  static const int ssnLength = 9;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var sanitizedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (sanitizedText.length > ssnLength) {
      // Truncate extra characters
      sanitizedText = sanitizedText.substring(0, ssnLength);
    }

    // Add hyphens to the formatted text
    final buffer = StringBuffer();
    for (int i = 0; i < sanitizedText.length; i++) {
      buffer.write(sanitizedText[i]);
      if (i == 2 || i == 4) {
        buffer.write('-');
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}