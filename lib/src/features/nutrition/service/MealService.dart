// there for the three of them breakfats lunch ....
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';

class MealService {
  Future<Map<String, dynamic>?> getClosestMeal(
    double targetCalories,
    double targetProtein,
    double targetCarbs,
    double targetFats,
    List<Map<String, dynamic>> foods,
    String mealType,
  ) async {
    Map<String, dynamic>? closestMeal;
    double smallestWeightedDiff = double.infinity;

    for (var food in foods) {
      double calories = (food['calories'] ?? 0.0).toDouble();
      double protein = (food['protein'] ?? 0.0).toDouble();
      double carbs = (food['carbs'] ?? 0.0).toDouble();
      double fats = (food['fat'] ?? 0.0).toDouble();

      double calorieDiff = (calories - targetCalories).abs();
      double proteinDiff = (protein - targetProtein).abs();
      double carbDiff = (carbs - targetCarbs).abs();
      double fatDiff = (fats - targetFats).abs();

      // Weighted differences: prioritize calories > protein > carbs > fats
      double totalWeightedDiff = (calorieDiff * 3) +
          (proteinDiff * 2.5) +
          (carbDiff * 2) +
          (fatDiff * 1.5);

      if (totalWeightedDiff < smallestWeightedDiff) {
        smallestWeightedDiff = totalWeightedDiff;
        closestMeal = food;
      }
    }
    return closestMeal;
  }
}

class MealPlanner {
  Future<List<Map<String, dynamic>>> planMeals(double targetCalories) async {
    // Define calorie distribution
    Map<String, double> mealCalories = {
      'breakfast': targetCalories * 0.28, // Example: 28% for breakfast
      'lunch': targetCalories * 0.48, // 48% for lunch
      'dinner': targetCalories * 0.24, // 24% for dinner
    };

    double proteinTarget = targetCalories * 0.4 / 4; // 40% from protein
    double carbTarget = targetCalories * 0.4 / 4; // 40% from carbs
    double fatTarget = targetCalories * 0.2 / 9; // 20% from fats

    // Fetch food options
    final breakfastFoods = await FoodService_breakfast().getFoods(100);
    final lunchFoods = await FoodService_launch().getFoods();
    final dinnerFoods = await FoodService_Dinner().getFoods();
    final snackFoods = await FoodService_snacks().getFoods();

    List<Map<String, dynamic>> selectedMeals = [];

    // Select meals
    for (var mealType in ['breakfast', 'lunch', 'dinner']) {
      double mealCaloriesTarget = mealCalories[mealType]!;
      List<Map<String, dynamic>> foodOptions = mealType == 'breakfast'
          ? breakfastFoods
          : mealType == 'lunch'
              ? lunchFoods
              : dinnerFoods;

      Map<String, dynamic>? meal = await MealService().getClosestMeal(
        mealCaloriesTarget,
        proteinTarget * mealCaloriesTarget / targetCalories,
        carbTarget * mealCaloriesTarget / targetCalories,
        fatTarget * mealCaloriesTarget / targetCalories,
        foodOptions,
        mealType,
      );

      if (meal != null) {
        selectedMeals.add(meal);

        // Adjust remaining targets
        targetCalories -= meal['calories'];
        proteinTarget -= meal['protein'];
        carbTarget -= meal['carbs'];
        fatTarget -= meal['fat'];
      }
    }

    // Add snacks if needed
    if (targetCalories > 0) {
      final snack = await MealService().getClosestMeal(
        targetCalories,
        proteinTarget,
        carbTarget,
        fatTarget,
        snackFoods,
        'snack',
      );
      if (snack != null) {
        selectedMeals.add(snack);
      }
    }

    // Ensure total calories are within acceptable range
    double totalCalories =
        selectedMeals.fold(0, (sum, meal) => sum + meal['calories']);
    if (totalCalories < targetCalories * 0.85 ||
        totalCalories > targetCalories * 1.15) {
      print("Total calories out of range. Adjusting...");
      // Handle cases where total calories deviate significantly
    }

    return selectedMeals;
  }
}
