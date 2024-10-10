// password_visibility_toggle.dart
import 'package:flutter/material.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onToggle;

  const PasswordVisibilityToggle({
    super.key,
    required this.isObscured,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
      onPressed: onToggle,
    );
  }
}
