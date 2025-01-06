import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Lunch.dart';

class Food_Card_Lunch extends StatelessWidget {
  const Food_Card_Lunch({
    super.key,
    required this.mincal,
    required this.maxcal,
    required this.remainingCalories,
    required this.description,
  });

  final dynamic mincal;
  final dynamic maxcal;
  final double remainingCalories;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Lunch(
      maxcal: maxcal,
      mincal: mincal,
      remainingCalories: remainingCalories,
      description: description,
    );
  }
}
