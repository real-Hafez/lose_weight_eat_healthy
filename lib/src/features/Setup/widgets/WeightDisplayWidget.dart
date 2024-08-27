import 'package:flutter/material.dart';

class WeightDisplayWidget extends StatelessWidget {
  final int weightKg;
  final int weightLb;
  final String weightUnit;

  const WeightDisplayWidget({
    super.key,
    required this.weightKg,
    required this.weightLb,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      weightUnit == 'kg'
          ? '$weightKg kg'
          : '$weightLb lb',
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
