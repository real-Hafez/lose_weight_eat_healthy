import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

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
        weightUnit == 'kg' ? '$weightKg ${S().kg}' : '$weightLb ${S().lb}',
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }
}
