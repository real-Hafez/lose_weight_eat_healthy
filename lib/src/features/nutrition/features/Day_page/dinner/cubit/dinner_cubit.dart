import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/dinner/cubit/dinner_state.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dinner_cubit extends Cubit<DinnerState> {
  final FoodService_Dinner _foodService = FoodService_Dinner();
  final MealService _mealService = MealService();

  Dinner_cubit() : super(DinnerState());

  Future<void> loadClosestMeal() async {
    emit(state.copyWith(isLoading: true));

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double proteinGrams = prefs.getDouble('proteinGrams') ?? 200;
      double carbsGrams = prefs.getDouble('carbsGrams') ?? 200;
      double fatsGrams = prefs.getDouble('fatsGrams') ?? 0;
      double calories = prefs.getDouble('calories') ?? 2000;

      // Calculate ranges for meal search
      double minProtein = proteinGrams * 0.01;
      double maxProtein = proteinGrams * 0.70;
      double minCarb = carbsGrams * 0.00;
      double maxCarb = carbsGrams * 0.70;
      double minCalories = calories * 0.01;
      double maxCalories = calories * 0.70;
      double minFat = fatsGrams * 0.10;
      double maxFat = fatsGrams * 0.99;

      // Fetch the list of foods
      List<Map<String, dynamic>> foods = await _foodService.getFoods(
        minCalories,
        maxCalories,
        minProtein,
        maxProtein,
        minCarb,
        maxCarb,
        minFat,
        maxFat,
      );

      // Get the closest meal
      final dinnerMeal = await _mealService.getClosestMeal(
        calories,
        proteinGrams,
        carbsGrams,
        fatsGrams,
        foods,
        'Dinner',
      );

      // Log chosen lunch meal
      if (dinnerMeal != null) {
        _logMealDetails(
          dinnerMeal,
          calories,
          proteinGrams,
          carbsGrams,
          fatsGrams,
        );

        Map<String, dynamic> DinnerMeal = {
          'calories': 850.0,
          'protein': 25.0,
          'carbs': 60.0,
          'fat': 45.0,
        };

        // Log combined meal totals
        _logMealDetailsWithRemaining(
          DinnerMeal,
          dinnerMeal,
          calories,
          proteinGrams,
          carbsGrams,
          fatsGrams,
        );
      }

      emit(state.copyWith(closestMeal: dinnerMeal, isLoading: false));
    } catch (e) {
      print('Error loading closest meal: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  // Helper method for logging meal details and calculating percentages
  void _logMealDetails(Map<String, dynamic> meal, double totalCalories,
      double proteinGrams, double carbsGrams, double fatsGrams) {
    final foodName = meal['food_Name_Arabic'] ?? 'Unknown';
    final foodCalories = (meal['calories'] as num?)?.toDouble() ?? 0.0;
    final foodProtein = (meal['protein'] as num?)?.toDouble() ?? 0.0;
    final foodCarbs = (meal['carbs'] as num?)?.toDouble() ?? 0.0;
    final foodFat = (meal['fat'] as num?)?.toDouble() ?? 0.0;

    // Calculate percentage contribution for each macronutrient
    final calPercentage = (foodCalories / totalCalories) * 100;
    final proteinPercentage = (foodProtein / proteinGrams) * 100;
    final carbsPercentage = (foodCarbs / carbsGrams) * 100;
    final fatPercentage = (foodFat / fatsGrams) * 100;

    // Log the meal details and percentage contributions
    print('--- Chosen Meal  for Dinner ---');
    print('Name: $foodName');
    print(
        'Calories: $foodCalories (${calPercentage.toStringAsFixed(2)}% of daily total)');
    print(
        'Protein: $foodProtein (${proteinPercentage.toStringAsFixed(2)}% of daily protein target)');
    print(
        'Carbs: $foodCarbs (${carbsPercentage.toStringAsFixed(2)}% of daily carb target)');
    print(
        'Fat: $foodFat (${fatPercentage.toStringAsFixed(2)}% of daily fat target)');
  }

  void markAsCompleted() {
    print('Marking lunch as completed');
    emit(state.copyWith(isCompleted: true));
  }

  void _logMealDetailsWithRemaining(
    Map<String, dynamic> breakfastMeal,
    Map<String, dynamic> lunchMeal,
    double totalCalories,
    double proteinGrams,
    double carbsGrams,
    double fatsGrams,
  ) {
    // Extract breakfast meal details
    final breakfastCalories =
        (breakfastMeal['calories'] as num?)?.toDouble() ?? 0.0;
    final breakfastProtein =
        (breakfastMeal['protein'] as num?)?.toDouble() ?? 0.0;
    final breakfastCarbs = (breakfastMeal['carbs'] as num?)?.toDouble() ?? 0.0;
    final breakfastFat = (breakfastMeal['fat'] as num?)?.toDouble() ?? 0.0;

    // Extract lunch meal details
    final lunchCalories = (lunchMeal['calories'] as num?)?.toDouble() ?? 0.0;
    final lunchProtein = (lunchMeal['protein'] as num?)?.toDouble() ?? 0.0;
    final lunchCarbs = (lunchMeal['carbs'] as num?)?.toDouble() ?? 0.0;
    final lunchFat = (lunchMeal['fat'] as num?)?.toDouble() ?? 0.0;

    // Calculate totals
    final totalCaloriesConsumed = breakfastCalories + lunchCalories;
    final totalProteinConsumed = breakfastProtein + lunchProtein;
    final totalCarbsConsumed = breakfastCarbs + lunchCarbs;
    final totalFatConsumed = breakfastFat + lunchFat;

    // Calculate remaining values
    final remainingCalories = totalCalories - totalCaloriesConsumed;
    final remainingProtein = proteinGrams - totalProteinConsumed;
    final remainingCarbs = carbsGrams - totalCarbsConsumed;
    final remainingFat = fatsGrams - totalFatConsumed;

    // Calculate percentages
    final remainingCaloriesPercent = (remainingCalories / totalCalories) * 100;
    final remainingProteinPercent = (remainingProtein / proteinGrams) * 100;
    final remainingCarbsPercent = (remainingCarbs / carbsGrams) * 100;
    final remainingFatPercent = (remainingFat / fatsGrams) * 100;

    // Log details
    print('--- Combined Meal Totals ---');
    print('Total Calories Consumed: $totalCaloriesConsumed');
    print(
        'Remaining Calories: $remainingCalories (${remainingCaloriesPercent.toStringAsFixed(2)}%)');
    print(
        'Remaining Protein: $remainingProtein (${remainingProteinPercent.toStringAsFixed(2)}%)');
    print(
        'Remaining Carbs: $remainingCarbs (${remainingCarbsPercent.toStringAsFixed(2)}%)');
    print(
        'Remaining Fat: $remainingFat (${remainingFatPercent.toStringAsFixed(2)}%)');
  }
}
