import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/ToggleButtonDay_Week_shoppingList.dart';

class Nutrition extends StatelessWidget {
  final FoodService foodService = FoodService();

  Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          ToggleButtonDay_Week_shoppingList(),
          SizedBox(height: 25),
          // nutrition_calender(),
          // SizedBox(height: 25),
          // CalorieTrackerWidget(),
          // SizedBox(height: 25),
          // Meal_Type_Display(food: "Breakfast"),
          // SizedBox(height: 1),
          // Food_days(),
        ],
      ),
    );
  }
}
