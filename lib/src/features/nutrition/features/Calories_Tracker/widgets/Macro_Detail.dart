import 'package:flutter/material.dart';

class Macro_Detail extends StatelessWidget {
  final IconData icon;
  final String label;

  const Macro_Detail({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
