import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

class Nutrition extends StatelessWidget {
  const Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          nutrition_calender(),
          SizedBox(
            height: 25,
          ),
          CalorieTrackerWidget(),
          SizedBox(
            height: 25,
          ),
          Meal_Type_Display(food: "Breakfast"),
          Food_Card(
            foodName: "foul",
            foodImage:
                'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_15%.jpg',
            calories: 100,
            weight: 150,
            fat: 10,
            carbs: 25,
            protein: 35,
          ),
          SizedBox(
            height: 120,
          ),
        ],
      ),
    );
  }
}
