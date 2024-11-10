import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CmPicker extends StatelessWidget {
  final int heightCm;
  final void Function(int value) onHeightChanged;

  const CmPicker({
    super.key,
    required this.heightCm,
    required this.onHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: heightCm,
      minValue: 95,
      maxValue: 241,
      onChanged: onHeightChanged,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.grey, ),
      selectedTextStyle:
          const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}
