import 'package:flutter/material.dart';

ThemeData dark_theme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4E9F3D)), // Example for bodyLarge
    bodyMedium: TextStyle(
        color: Color.fromARGB(255, 168, 233, 188)), // Example for bodyMedium
    displayLarge:
        TextStyle(color: Color(0xFF1E5128)), // Example for displayLarge
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xff191A19),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xff2E2E2E), // Background color of the text field
    focusColor: const Color(0xFF1E5128), // Color when the text field is focused
    hoverColor:
        const Color(0xFF4E9F3D), // Color when hovering over the text field
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF4E9F3D)), // Border color
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color(0xFF1E5128)), // Focused border color
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color(0xFF4E9F3D)), // Enabled border color
      borderRadius: BorderRadius.circular(12.0),
    ),
    hintStyle: const TextStyle(color: Color(0xFFD8E9A8)), // Hint text color
    labelStyle: const TextStyle(color: Color(0xFF4E9F3D)), // Label text color
  ),
);
