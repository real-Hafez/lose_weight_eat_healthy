import 'package:flutter/material.dart';

class HeightDisplayWidget extends StatelessWidget {
  final int heightCm;
  final int heightFt;
  final int heightInches;
  final String heightUnit;

  const HeightDisplayWidget({
    Key? key,
    required this.heightCm,
    required this.heightFt,
    required this.heightInches,
    required this.heightUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        heightUnit == 'cm'
            ? '$heightCm cm'
            : '$heightFt\'$heightInches"',
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
