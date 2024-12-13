import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_card_Snacks.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

class Dayview extends StatefulWidget {
  const Dayview({super.key});

  @override
  _DayviewState createState() => _DayviewState();
}

class _DayviewState extends State<Dayview> {
  bool breakfastMinimized = false;
  bool lunchMinimized = false;
  bool dinnerMinimized = false;
  bool snacksMinimized = false;

  void toggleBreakfastMinimize() {
    setState(() {
      breakfastMinimized = !breakfastMinimized;
    });
  }

  void toggleLunchMinimize() {
    setState(() {
      lunchMinimized = !lunchMinimized;
    });
  }

  void toggleDinnerMinimize() {
    setState(() {
      dinnerMinimized = !dinnerMinimized;
    });
  }

  void toggleSnacksMinimize() {
    setState(() {
      snacksMinimized = !snacksMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Nutrition_Calendar(),
            const SizedBox(height: 25),
            const CalorieTrackerWidget(),
            const SizedBox(height: 25),
            Meal_Type_Display(
              food: S().Breakfast,
              minmize: breakfastMinimized,
              onToggleMinimize: toggleBreakfastMinimize,
            ),
            if (!breakfastMinimized) const Food_Card_Breakfast(),
            Meal_Type_Display(
              food: S().Lunch,
              minmize: lunchMinimized,
              onToggleMinimize: toggleLunchMinimize,
              // onToggleMini mize: toggleLunchMinimize,
            ),
            if (!lunchMinimized) const Food_Card_Lunch(),
            Meal_Type_Display(
              food: S().Dinner,
              minmize: dinnerMinimized,
              onToggleMinimize: toggleDinnerMinimize,
            ),
            if (!dinnerMinimized) const Food_Card_Dinner(),
            Meal_Type_Display(
              food: S().Snacks,
              minmize: snacksMinimized,
              onToggleMinimize: toggleSnacksMinimize,
            ),
            // if (!snacksMinimized) const Food_Card_snacks(),
          ],
        ),
      ),
    );
  }
}
