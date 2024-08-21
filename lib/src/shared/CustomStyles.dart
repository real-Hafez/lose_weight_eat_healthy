import 'package:flutter/material.dart';

class CustomStyles {
  static TextStyle labelStyle(BuildContext context, bool hasError) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * .02,
      color: hasError ? Colors.red : Colors.white,
    );
  }

  static TextStyle requiredMarkStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * .02,
      color: Colors.red,
    );
  }

  static InputDecoration inputDecoration({
    required String hintText,
    required bool hasError,
    required bool isPassword,
    required bool isChecking,
    required bool hasStartedTyping,
    required bool isUsernameTaken,
    required bool isObscureText,
    required VoidCallback? onTogglePasswordVisibility,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(22),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onTogglePasswordVisibility,
            )
          : isChecking
              ? const SizedBox(child: CircularProgressIndicator())
              : hasStartedTyping
                  ? isUsernameTaken
                      ? const Icon(Icons.close, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green)
                  : null,
    );
  }
}
