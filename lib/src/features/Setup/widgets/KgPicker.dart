import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class KgPicker extends StatelessWidget {
  final int weightKg;
  final ValueChanged<int> onWeightChanged;

  const KgPicker({
    super.key,
    required this.weightKg,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: weightKg,
      minValue: 30,
      maxValue: 200,
      onChanged: onWeightChanged,
      textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
      selectedTextStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}
