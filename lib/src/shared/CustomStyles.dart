import 'package:flutter/material.dart';

class CustomStyles {
  static TextStyle labelStyle(BuildContext context, bool hasError) {
    final theme = Theme.of(context).textTheme;

    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * .02,
      color: hasError ? Colors.red : theme.bodyLarge?.color ?? Colors.white,
    );
  }

  static TextStyle requiredMarkStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * .02,
      color: Colors.red,
    );
  }

  static InputDecoration inputDecoration({
    required BuildContext context,
    required String hintText,
    required bool hasError,
    required bool isPassword,
    required bool isChecking,
    required bool hasStartedTyping,
    required bool isUsernameTaken,
    required bool isObscureText,
    required VoidCallback? onTogglePasswordVisibility,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
        color: hasError
            ? Colors.red
            : theme.inputDecorationTheme.hintStyle?.color ?? Colors.grey,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      filled: true,
      fillColor:
          theme.inputDecorationTheme.fillColor, // Apply the theme's fill color
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: hasError
              ? Colors.red
              : theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                  Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: hasError
              ? Colors.red
              : theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
                  Colors.blue, // Fallback color if theme is not set
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
              ),
              onPressed: onTogglePasswordVisibility,
            )
          : isChecking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : hasStartedTyping
                  ? isUsernameTaken
                      ? const Icon(Icons.close, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green)
                  : null,
    );
  }
}
