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
    _checkAndResetForNewDay();
  }

  Future<void> _checkAndResetForNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastUpdatedDay = prefs.getString('lastUpdatedDay');
    String currentDay = DateTime.now().toIso8601String().split('T').first;

    if (lastUpdatedDay == null || lastUpdatedDay != currentDay) {
      await prefs.setString('lastUpdatedDay', currentDay);
      await prefs.setBool('breakfastMinimized', false);
      await prefs.setBool('lunchMinimized', false);
      await prefs.setBool('dinnerMinimized', false);

      // Clear completed states for meals
      await prefs.remove('Breakfast_completed');
      await prefs.remove('Lunch_completed');
      await prefs.remove('Dinner_completed');

      setState(() {
        breakfastMinimized = false;
        lunchMinimized = false;
        dinnerMinimized = false;
      });
    } else {
      _loadMealStates();
    }
  }

  Future<void> _loadMealStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      breakfastMinimized = prefs.getBool('breakfastMinimized') ?? false;
      lunchMinimized = prefs.getBool('lunchMinimized') ?? false;
      dinnerMinimized = prefs.getBool('dinnerMinimized') ?? false;
    });
  }

  void toggleBreakfastMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      breakfastMinimized = !breakfastMinimized;
    });
    await prefs.setBool('breakfastMinimized', breakfastMinimized);
  }

  void toggleLunchMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lunchMinimized = !lunchMinimized;
    });
    await prefs.setBool('lunchMinimized', lunchMinimized);
  }

  void toggledinnerMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dinnerMinimized = !dinnerMinimized;
    });
    await prefs.setBool('dinnerMinimized', dinnerMinimized);
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
                description: '',
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
                description: '',
              ),
            // Dinner Section
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
                description: '',
              ),
          ],
        ),
      ),
    );
  }
}
