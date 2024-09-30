import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Progress_Indicator.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Macro_Detail.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Nutrition_Detail.dart';

class Daily_Nutrition_Card extends StatelessWidget {
  const Daily_Nutrition_Card({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: const Color(0xFF5958D0),
          borderRadius: BorderRadius.circular(25.0)),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nutrition Budget",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Calorie_Progress_Indicator(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutritionDetail(label: "Consumed", value: "1556 kcal"),
              NutritionDetail(label: "Burned", value: "221 kcal"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Macro_Detail(
                icon: Icons.local_pizza,
                label: "17% Fat",
              ),
              Macro_Detail(
                icon: Icons.rice_bowl,
                label: "54% Carbs",
              ),
              Macro_Detail(
                icon: Icons.fitness_center,
                label: "29% Protein",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
