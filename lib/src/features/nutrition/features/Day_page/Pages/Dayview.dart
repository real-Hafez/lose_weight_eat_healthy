import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dayview extends StatefulWidget {
  const Dayview({super.key});

  @override
  _DayviewState createState() => _DayviewState();
}

class _DayviewState extends State<Dayview> {
  bool breakfastMinimized = false;
  bool lunchMinimized = false;
  bool dinnerMinimized = false;
  double totalCalories = 2959.0; // Default daily calorie allowance
  double breakfastCalories = 0.0;
  double lunchCalories = 1500.0; // Initialize here directly

  double get remainingAfterBreakfast => totalCalories - breakfastCalories;
  double get remainingAfterLunch =>
      totalCalories - (breakfastCalories + lunchCalories);

  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalCalories = prefs.getDouble('calories') ?? 2959.0;
      breakfastCalories = 850.0;
      lunchCalories =
          1500.0; // Set lunch calories here instead of inside Builder
    });
  }

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

  void toggledinnerMinimize() {
    setState(() {
      dinnerMinimized = !dinnerMinimized;
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

            // Breakfast Section
            Meal_Type_Display(
              food: S().Breakfast,
              minmize: breakfastMinimized,
              onToggleMinimize: toggleBreakfastMinimize,
            ),
            if (!breakfastMinimized)
              Food_Card_Breakfast(
                  remainingCalories: remainingAfterBreakfast,
                  mincal: 0.20,
                  maxcal: 0.30,
                  description: ''
                  // 'Breakfast calories: $breakfastCalories. Remaining calories: ${remainingAfterBreakfast.toStringAsFixed(0)} cal.',
                  ),

            // Lunch Section
            Meal_Type_Display(
              food: S().Lunch,
              minmize: lunchMinimized,
              onToggleMinimize: toggleLunchMinimize,
            ),
            if (!lunchMinimized)
              Food_Card_Lunch(
                  remainingCalories: remainingAfterLunch,
                  mincal: 0.60,
                  maxcal: 0.80,
                  description: ''
                  // 'Lunch calories: $lunchCalories. Remaining calories: ${remainingAfterLunch.toStringAsFixed(0)} cal.',
                  ),
            Meal_Type_Display(
              food: S().Dinner,
              minmize: dinnerMinimized,
              onToggleMinimize: toggledinnerMinimize,
            ),
            if (!dinnerMinimized)
              Food_Card_Dinner(
                  remainingCalories: remainingAfterLunch,
                  mincal: 0.10,
                  maxcal: 0.20,
                  description: ''
                  // 'Lunch calories: $lunchCalories. Remaining calories: ${remainingAfterLunch.toStringAsFixed(0)} cal.'
                  // ,
                  ),
          ],
        ),
      ),
    );
  }
}
