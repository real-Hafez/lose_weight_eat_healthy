import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Breakfast/cubit/breakfast_state.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreakfastCubit extends Cubit<BreakfastState> {
  final FoodService_breakfast _foodService = FoodService_breakfast();
  final MealService _mealService = MealService();

  BreakfastCubit() : super(BreakfastState());

  // Future<void> loadClosestMeal() async {
  //   emit(state.copyWith(isLoading: true));

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();

  //     double proteinGrams = prefs.getDouble('proteinGrams') ?? 200;
  //     double carbsGrams = prefs.getDouble('carbsGrams') ?? 200;
  //     double fatsGrams = prefs.getDouble('fatsGrams') ?? 0;
  //     double calories = prefs.getDouble('calories') ?? 2000;

  //     // Calculate ranges for meal search
  //     double minProtein = proteinGrams * 0.01;
  //     double maxProtein = proteinGrams * 0.70;
  //     double minCarb = carbsGrams * 0.00;
  //     double maxCarb = carbsGrams * 0.70;
  //     double minCalories = calories * 0.01;
  //     double maxCalories = calories * 0.70;
  //     double minFat = fatsGrams * 0.10;
  //     double maxFat = fatsGrams * 0.99;

  //     // Fetch the list of foods
  //     List<Map<String, dynamic>> foods = await _foodService.getFoods(
  //       minCalories,
  //       maxCalories,
  //       minProtein,
  //       maxProtein,
  //       minCarb,
  //       maxCarb,
  //       minFat,
  //       maxFat,
  //     );

  //     // Get the closest meal
  //     final closestMeal = await _mealService.getClosestMeal(
  //       calories,
  //       proteinGrams,
  //       carbsGrams,
  //       fatsGrams,
  //       foods,
  //       'Breakfast',
  //     );

  //     // Log chosen meal details for debugging
  //     if (closestMeal != null) {
  //       _logMealDetails(closestMeal, calories, proteinGrams, carbsGrams,
  //           fatsGrams); // Log details with macronutrient percentages
  //     }

  //     emit(state.copyWith(closestMeal: closestMeal, isLoading: false));
  //   } catch (e) {
  //     print('Error loading closest meal: $e');
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }

  // // Helper method for logging meal details and calculating percentages
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
    print('--- Chosen Meal ---');
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
    print('Marking breakfast as completed');
    emit(state.copyWith(isCompleted: true));
  }
}
