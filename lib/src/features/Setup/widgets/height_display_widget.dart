import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class HeightDisplayWidget extends StatelessWidget {
  final int heightCm;
  final int heightFt;
  final int heightInches;
  final String heightUnit;

  const HeightDisplayWidget({
    super.key,
    required this.heightCm,
    required this.heightFt,
    required this.heightInches,
    required this.heightUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        heightUnit == 'cm'
            ? '$heightCm ${S().cm}'
            : '$heightFt\'$heightInches ${S().ft} ',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * .15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
