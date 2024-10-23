import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

class Dayview extends StatelessWidget {
  const Dayview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            nutrition_calender(),
            SizedBox(height: 25),
            CalorieTrackerWidget(),
            SizedBox(height: 25),
            Meal_Type_Display(food: "Breakfast"),
            SizedBox(height: 1),
            Food_Card_Breakfast(),
            Meal_Type_Display(food: "Lunch"),
            Food_Card_Lunch(),
            Meal_Type_Display(food: "Dinner"),
            Food_Card_Dinner(),
          ],
        ),
      ),
    );
  }
}
