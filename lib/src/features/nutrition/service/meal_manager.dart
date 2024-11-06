// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
// import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class MealManager {
//   static const String _mealKeyPrefix = 'meals_for_date_';

//   // Save selected meals for a specific date
//   static Future<void> saveMealsForDate(
//       DateTime date, Map<String, int> mealIds) async {
//     final prefs = await SharedPreferences.getInstance();
//     final dateKey = _getDateKey(date);
//     await prefs.setString(dateKey, json.encode(mealIds));
//   }

//   // Get saved meals for a specific date
//   static Future<Map<String, int>?> getMealsForDate(DateTime date) async {
//     final prefs = await SharedPreferences.getInstance();
//     final dateKey = _getDateKey(date);
//     final savedMeals = prefs.getString(dateKey);
//     if (savedMeals != null) {
//       return Map<String, int>.from(json.decode(savedMeals));
//     }
//     return null;
//   }

//   // Generate meals for a specific date if not already saved
//   static Future<Map<String, int>> generateMealsForDate(
//     DateTime date,
//     String userId,
//     double targetCalories,
//     double targetProtein,
//     double targetCarbs,
//     double targetFats,
//   ) async {
//     // Check if meals already exist for this date
//     final existingMeals = await getMealsForDate(date);
//     if (existingMeals != null) {
//       return existingMeals;
//     }

//     // Generate new meals based on user's nutritional needs
//     final mealIds = await _generateNewMeals(
//       userId,
//       targetCalories,
//       targetProtein,
//       targetCarbs,
//       targetFats,
//     );

//     // Save the generated meals
//     await saveMealsForDate(date, mealIds);
//     return mealIds;
//   }

//   static String _getDateKey(DateTime date) {
//     return '${_mealKeyPrefix}${date.year}-${date.month}-${date.day}';
//   }

//   static Future<Map<String, int>> _generateNewMeals(
//     String userId,
//     double targetCalories,
//     double targetProtein,
//     double targetCarbs,
//     double targetFats,
//   ) async {
//     // Initialize services
//     final breakfastService = FoodService_breakfast();
//     final lunchService = FoodService_launch();
//     final dinnerService = FoodService_Dinner();
//     final snacksService = FoodService_snacks();

//     // Get meals data
//     final breakfastFoods = await breakfastService.getFoods();
//     final lunchFoods = await lunchService.getFoods();
//     final dinnerFoods = await dinnerService.getFoods();
//     final snacksFoods = await snacksService.getFoods();

//     // Calculate meal-specific targets
//     final mealService = MealService();

//     final breakfast = await mealService.getClosestMeal(
//       targetCalories * 0.25,
//       targetProtein * 0.25,
//       targetCarbs * 0.25,
//       targetFats * 0.25,
//       breakfastFoods,
//       'Breakfast',
//     );

//     final lunch = await mealService.getClosestMeal(
//       targetCalories * 0.35,
//       targetProtein * 0.35,
//       targetCarbs * 0.35,
//       targetFats * 0.35,
//       lunchFoods,
//       'Lunch',
//     );

//     final dinner = await mealService.getClosestMeal(
//       targetCalories * 0.30,
//       targetProtein * 0.30,
//       targetCarbs * 0.30,
//       targetFats * 0.30,
//       dinnerFoods,
//       'Dinner',
//     );

//     final snacks = await mealService.getClosestMeal(
//       targetCalories * 0.10,
//       targetProtein * 0.10,
//       targetCarbs * 0.10,
//       targetFats * 0.10,
//       snacksFoods,
//       'Snacks',
//     );

//     return {
//       'breakfast': breakfast?['id'] ?? 0,
//       'lunch': lunch?['id'] ?? 0,
//       'dinner': dinner?['id'] ?? 0,
//       'snacks': snacks?['id'] ?? 0,
//     };
//   }
// }
