import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_card_Snacks.dart';
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
  bool snacksMinimized = false;
  double totalCalories =
      2000.0; // Default calories, will be fetched from SharedPreferences
  double breakfastCalories =
      0.0; // To hold the calories for breakfast (set dynamically)
  double remainingCalories = 0.0; // To hold remaining calories for the day

  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch total user calories from SharedPreferences
    totalCalories = prefs.getDouble('calories') ?? 2000.0;

    // Simulated breakfast calories (replace this with actual breakfast data fetching logic)
    breakfastCalories = 600.0; // Example: breakfast calories
    // Calculate remaining calories
    remainingCalories = totalCalories - breakfastCalories;

    setState(() {});
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
    // Calculate the percentage of the remaining calories
    double remainingCaloriesPercentage =
        (remainingCalories / totalCalories) * 100;

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
            if (!breakfastMinimized)
              Food_Card_Breakfast(
                remainingCalories: remainingCalories,
                mincal: 0.00,
                maxcal: 0.10,
                description:
                    'Breakfast calories: $breakfastCalories, remaining calories: $remainingCalories (${remainingCaloriesPercentage.toStringAsFixed(1)}%) for the day.',
              ),
            Meal_Type_Display(
              food: S().Lunch,
              minmize: lunchMinimized,
              onToggleMinimize: toggleLunchMinimize,
            ),
            if (!lunchMinimized)
              Food_Card_Lunch(
                remainingCalories: remainingCalories,
                mincal: 0.00,
                maxcal: 0.10,
                description:
                    'Breakfast calories: $breakfastCalories, remaining calories: $remainingCalories (${remainingCaloriesPercentage.toStringAsFixed(1)}%) for the day.',
              ),
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
          ],
        ),
      ),
    );
  }
}
