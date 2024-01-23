import 'package:flutter/foundation.dart';

class GenericEnum<T> {
  // Get enum value...
  T getEnumValue({
    required String? key,
    required List<T> enumValues,
    List<String> customEnumValue = const [],
    required T defaultEnumValue,
  }) {
    // Assign default value...
    T enumType = defaultEnumValue;
    for (int i = 0; i < enumValues.length; i++) {
      String _type = customEnumValue.isEmpty
          ? describeEnum(enumValues[i]!).toLowerCase()
          : customEnumValue[i].toLowerCase();
      // Compare key and T (Enum) value...
      if ((key?.toString().toLowerCase() ?? "") == _type) {
        // If compare return value...
        enumType = enumValues[i];
        break;
      }
    }
    return enumType;
  }
}
