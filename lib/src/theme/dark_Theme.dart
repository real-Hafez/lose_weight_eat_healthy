import 'package:flutter/material.dart';

ThemeData dark_theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF0D0B02), // A vibrant green for primary color
  hintColor: Color(0xFF0D0B02), // Complementary green for accent

  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Color.fromARGB(255, 244, 244, 244)), // Soft lime for headings
    bodyMedium: TextStyle(
        color: Color.fromARGB(255, 233, 233, 233)), // Light green for body text
    displayLarge: TextStyle(
        color: Color.fromARGB(255, 253, 253, 253)), // Bright green for display
  ),

  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF0D0B02), // Dark gray background for balance
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF333333), // Background color of text field
    focusColor: const Color(0xFF66BB6A), // Focused border and hover color
    hoverColor: const Color(0xFF388E3C), // Deeper green on hover

    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF81C784)), // Standard border
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF4CAF50)), // Focused border
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF66BB6A)), // Enabled border
      borderRadius: BorderRadius.circular(12.0),
    ),
    hintStyle:
        const TextStyle(color: Color(0xFF9E9E9E)), // Hint text for contrast
    labelStyle: const TextStyle(color: Color(0xFFB2FF59)), // Label text color
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color(0xFF388E3C)), // Dark green
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white), // White text
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  ),
);
