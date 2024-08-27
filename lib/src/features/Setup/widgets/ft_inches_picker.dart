import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class FtInchesPicker extends StatelessWidget {
  final int heightFt;
  final int heightInches;
  final void Function(int value) onFtChanged;
  final void Function(int value) onInchesChanged;

  const FtInchesPicker({
    Key? key,
    required this.heightFt,
    required this.heightInches,
    required this.onFtChanged,
    required this.onInchesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: heightFt,
          minValue: 3,
          maxValue: 7,
          onChanged: onFtChanged,
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        NumberPicker(
          value: heightInches,
          minValue: 0,
          maxValue: 11,
          onChanged: onInchesChanged,
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
