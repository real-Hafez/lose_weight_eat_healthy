import 'package:flutter/widgets.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Breakfast.dart';

class Food_Card_Breakfast extends StatelessWidget {
  const Food_Card_Breakfast({
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
    return Breakfast(
      maxcal: maxcal,
      mincal: mincal,
      remainingCalories: remainingCalories,
      description: description,
    );
  }
}
