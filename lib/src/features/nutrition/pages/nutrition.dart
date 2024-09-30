import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/nutrition_calender.dart';

class Nutrition extends StatelessWidget {
  const Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        nutrition_calender(),
        Expanded(child: NutritionBudgetWidget()),
      ],
    );
  }
}
