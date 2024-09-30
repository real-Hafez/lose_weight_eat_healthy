import 'package:flutter/material.dart';

class NutritionDetail extends StatelessWidget {
  final String label;
  final String value;

  const NutritionDetail({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
