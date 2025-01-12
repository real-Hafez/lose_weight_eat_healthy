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
  double totalCalories = 1747;
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
    int day = prefs.getInt('currentDay') ?? 0;

    // Avoid redundant calls to `_loadMealPlanForDay`
    if (currentDay != day) {
      setState(() {
        currentDay = day;
      });
      await _loadMealPlanForDay(day);
    }
  }

  Future<void> _loadMealPlanForDay(int day) async {
    Map<String, dynamic> mealPlan =
        await _mealPlanService.getMealPlanForDay(day);
    setState(() {
      currentMealPlan = mealPlan;
    });

    // Log current meal plan for debugging
    print("Loaded meal plan for day $day: $currentMealPlan");

    // Directly pass the actual calorie values for breakfast, lunch, and dinner
    double breakfastTarget = breakfastCalories;
    Map<String, dynamic> closestBreakfast =
        await _mealPlanService.findClosestMealPlan(
      'breakfast',
      breakfastTarget,
      totalCalories,
    );
    if (closestBreakfast.isNotEmpty &&
        closestBreakfast['description'].contains('Day $day')) {
      setState(() {
        currentMealPlan!['breakfast'] = closestBreakfast;
      });
      print("Updated breakfast: $closestBreakfast");
    }

    double lunchTarget = lunchCalories;
    Map<String, dynamic> closestLunch =
        await _mealPlanService.findClosestMealPlan(
      'lunch',
      lunchTarget,
      totalCalories,
    );
    if (closestLunch.isNotEmpty &&
        closestLunch['description'].contains('Day $day')) {
      setState(() {
        currentMealPlan!['lunch'] = closestLunch;
      });
      print("Updated lunch: $closestLunch");
    }

    double dinnerTarget = remainingAfterLunch;
    Map<String, dynamic> closestDinner =
        await _mealPlanService.findClosestMealPlan(
      'dinner',
      dinnerTarget,
      totalCalories,
    );
    if (closestDinner.isNotEmpty &&
        closestDinner['description'].contains('Day $day')) {
      setState(() {
        currentMealPlan!['dinner'] = closestDinner;
      });
      print("Updated dinner: $closestDinner");
    }

    print('Final updated meal plan: $currentMealPlan');
  }

  Future<void> _checkAndResetForNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUpdatedDay = prefs.getString('lastUpdatedDay');
    String currentDate = DateTime.now().toIso8601String().split('T').first;

    if (lastUpdatedDay == null || lastUpdatedDay != currentDate) {
      await prefs.setString('lastUpdatedDay', currentDate);

      // Increment the current day if needed
      int currentDay = prefs.getInt('currentDay') ?? 0;
      await prefs.setInt('currentDay', currentDay + 1);

      // Reset minimization states for a new day
      await prefs.setBool('breakfastMinimized', false);
      await prefs.setBool('lunchMinimized', false);
      await prefs.setBool('dinnerMinimized', false);

      // Force reload the meal plan for the new day
      setState(() {
        breakfastMinimized = false;
        lunchMinimized = false;
        dinnerMinimized = false;
      });
      await _loadCurrentDay();
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
              mealCalories: (currentMealPlan?['breakfast']['mincal'] ?? 0) *
                  totalCalories,
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
              mealCalories:
                  (currentMealPlan?['lunch']['mincal'] ?? 0) * totalCalories,
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
              mealCalories:
                  (currentMealPlan?['dinner']['mincal'] ?? 0) * totalCalories,
            ),
            if (!dinnerMinimized && currentMealPlan != null)
              Food_Card_Dinner(
                remainingCalories: remainingAfterLunch,
                mincal: currentMealPlan!['dinner']['mincal'],
                maxcal: currentMealPlan!['dinner']['maxcal'],
                description: currentMealPlan!['dinner']['description'],
              ),
            // Text(
            //   'Today is day $currentDay',
            //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
