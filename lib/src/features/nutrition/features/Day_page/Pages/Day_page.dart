import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/ToggleButtonDay_Week_shoppingList.dart';

class DayPage extends StatelessWidget {
  const DayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const ToggleButtonDay_Week_shoppingList(), // Mark static widgets as const
            const SizedBox(height: 25),
            const nutrition_calender(),
            const SizedBox(height: 25),
            const CalorieTrackerWidget(),
            const SizedBox(height: 25),
            const Meal_Type_Display(food: "Breakfast"),
            const SizedBox(height: 1),
            const Food_days(),
          ],
        ),
      ),
    );
  }
}
