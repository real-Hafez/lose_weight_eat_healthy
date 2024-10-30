import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Daily_Nutrition_Card.dart';

class CalorieTrackerWidget extends StatelessWidget {
  const CalorieTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Daily_Nutrition_Card(),
    );
  }
}
