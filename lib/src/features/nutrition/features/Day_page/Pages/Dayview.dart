import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/mealPlans.dart';
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
  double totalCalories = 2959.0;
  double breakfastCalories = 0.0;
  double lunchCalories = 1500.0;
  Map<String, dynamic>? currentMealPlan;
  int currentDay = 0;

  final MealPlanService _mealPlanService = MealPlanService();

  double get remainingAfterBreakfast => totalCalories - breakfastCalories;
  double get remainingAfterLunch =>
      totalCalories - (breakfastCalories + lunchCalories);

  @override
  void initState() {
    super.initState();
    _checkAndResetForNewDay();
    _loadCurrentDay();
    _loadMinimizationStates(); // Load saved minimization states
  }

  Future<void> _loadCurrentDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int day = await _mealPlanService.getCurrentDay();
    setState(() {
      currentDay = day;
    });
    _loadMealPlanForDay(day);
  }

  Future<void> _loadMealPlanForDay(int day) async {
    Map<String, dynamic> mealPlan =
        await _mealPlanService.getMealPlanForDay(day);
    setState(() {
      currentMealPlan = mealPlan;
    });
  }

  Future<void> _checkAndResetForNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUpdatedDay = prefs.getString('lastUpdatedDay');
    String currentDay = DateTime.now().toIso8601String().split('T').first;

    if (lastUpdatedDay == null || lastUpdatedDay != currentDay) {
      await prefs.setString('lastUpdatedDay', currentDay);
      await _mealPlanService.incrementDay();

      // Reset minimization states for a new day
      await prefs.setBool('breakfastMinimized', false);
      await prefs.setBool('lunchMinimized', false);
      await prefs.setBool('dinnerMinimized', false);

      setState(() {
        breakfastMinimized = false;
        lunchMinimized = false;
        dinnerMinimized = false;
      });

      await _loadCurrentDay(); // Load the new day's meal plan
    }
  }

  Future<void> _loadMinimizationStates() async {
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
            Meal_Type_Display(
              food: S().Breakfast,
              minmize: breakfastMinimized,
              onToggleMinimize: toggleBreakfastMinimize,
            ),
            if (!breakfastMinimized && currentMealPlan != null)
              Food_Card_Breakfast(
                remainingCalories: remainingAfterBreakfast,
                mincal: currentMealPlan!['breakfast']['mincal'],
                maxcal: currentMealPlan!['breakfast']['maxcal'],
                description: _mealPlanService.getDescription(
                    currentMealPlan, 'breakfast'),
              ),
            Meal_Type_Display(
              food: S().Lunch,
              minmize: lunchMinimized,
              onToggleMinimize: toggleLunchMinimize,
            ),
            if (!lunchMinimized && currentMealPlan != null)
              Food_Card_Lunch(
                remainingCalories: remainingAfterLunch,
                mincal: currentMealPlan!['lunch']['mincal'],
                maxcal: currentMealPlan!['lunch']['maxcal'],
                description: currentMealPlan!['lunch']['description'],
              ),
            Meal_Type_Display(
              food: S().Dinner,
              minmize: dinnerMinimized,
              onToggleMinimize: toggledinnerMinimize,
            ),
            if (!dinnerMinimized && currentMealPlan != null)
              Food_Card_Dinner(
                remainingCalories: remainingAfterLunch,
                mincal: currentMealPlan!['dinner']['mincal'],
                maxcal: currentMealPlan!['dinner']['maxcal'],
                description: currentMealPlan!['dinner']['description'],
              ),
            Text(
              'Today is day $currentDay',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
