import 'package:flutter/material.dart';

ThemeData light_theme = ThemeData(
  brightness: Brightness.light,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4C3F91)), // Deep purple for bodyLarge
    bodyMedium:
        TextStyle(color: Color(0xFF9145B6)), // Lighter purple for bodyMedium
    displayLarge:
        TextStyle(color: Color(0xFFB958A5)), // Magenta for displayLarge
  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFF5677), // Pinkish surface color for contrast
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:
        const Color(0xFFF4E5FC), // Light lavender for text field background
    focusColor:
        const Color(0xFF9145B6), // Same purple as bodyMedium for focus color
    hoverColor: const Color(0xFFB958A5), // Magenta for hover color
    border: OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color(0xFF4C3F91)), // Deep purple for borders
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
          color: Color(0xFF9145B6)), // Purple for focused border
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
          color: Color(0xFF4C3F91)), // Deep purple for enabled border
      borderRadius: BorderRadius.circular(12.0),
    ),
    hintStyle:
        const TextStyle(color: Color(0xFFB958A5)), // Magenta for hint text
    labelStyle:
        const TextStyle(color: Color(0xFF9145B6)), // Purple for label text
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF4C3F91)), // Pinkish color for button background
      foregroundColor:
          WidgetStateProperty.all<Color>(Colors.white), // White text color
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  ),
);
