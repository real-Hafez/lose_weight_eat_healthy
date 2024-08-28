import 'package:flutter/material.dart';

class WeightDisplayWidget extends StatelessWidget {
  final double weightKg;
  final double weightLb;
  final String weightUnit;

  const WeightDisplayWidget({
    super.key,
    required this.weightKg,
    required this.weightLb,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        weightUnit == 'kg' ? '$weightKg kg' : '$weightLb lb',
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }
}
