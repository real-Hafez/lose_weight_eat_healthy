import 'package:flutter/material.dart';

class ArabicStyle {
  // Light style for Arabic text
  static TextStyle arabicLightStyle({double fontSize = 16.0}) {
    return TextStyle(
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w300,
      fontSize: fontSize,
    );
  }

  // Regular style for Arabic text
  static TextStyle arabicRegularStyle({double fontSize = 18.0}) {
    return TextStyle(
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    );
  }

  // Medium style for Arabic text
  static TextStyle arabicMediumStyle({double fontSize = 20.0}) {
    return TextStyle(
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
  }

  // SemiBold style for Arabic text
  static TextStyle arabicSemiBoldStyle({double fontSize = 22.0}) {
    return TextStyle(
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    );
  }

  // Bold style for Arabic text
  static TextStyle arabicBoldStyle({double fontSize = 24.0}) {
    return TextStyle(
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
  }
}
