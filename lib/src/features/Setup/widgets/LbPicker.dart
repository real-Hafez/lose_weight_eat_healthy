import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class LbPicker extends StatelessWidget {
  final int weightLb;
  final ValueChanged<int> onWeightChanged;

  const LbPicker({
    super.key,
    required this.weightLb,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: weightLb,
      minValue: 66, // Approximate minimum weight in pounds
      maxValue: 440, // Approximate maximum weight in pounds
      onChanged: onWeightChanged,
      textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
      selectedTextStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}
