import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';

class MealFinder {
  Future<List<Map<String, dynamic>>> findMeals(double userCalories) async {
    final foodServiceBreakfast = FoodService_breakfast();
    final foodServiceLunch = FoodService_launch();
    final foodServiceDinner = FoodService_Dinner();
    final foodServiceSnacks =
        FoodService_snacks(); // Adjusted to use FoodService_snacks

    List<Map<String, dynamic>> breakfastFoods =
        await foodServiceBreakfast.getFoods();
    List<Map<String, dynamic>> lunchFoods = await foodServiceLunch.getFoods();
    List<Map<String, dynamic>> dinnerFoods = await foodServiceDinner.getFoods();
    List<Map<String, dynamic>> snackFoods =
        await foodServiceSnacks.getFoods(); // Get snack foods

    if (breakfastFoods.isEmpty ||
        lunchFoods.isEmpty ||
        dinnerFoods.isEmpty ||
        snackFoods.isEmpty) {
      return []; // Handle the case where there are no foods available
    }

    // Target daily macronutrient breakdown
    double targetCalories = userCalories;
    double targetProtein = userCalories * 0.4 / 4;
    double targetCarbs = userCalories * 0.4 / 4;
    double targetFats = userCalories * 0.2 / 9;

    List<Map<String, dynamic>> selectedMeals = [];

    // Select breakfast
    selectedMeals.add(_selectMeal(
        "Breakfast",
        breakfastFoods,
        targetCalories * 0.3,
        targetProtein * 0.3,
        targetCarbs * 0.3,
        targetFats * 0.3));
    double remainingCalories =
        targetCalories - (selectedMeals.last['calories'] ?? 0);
    double remainingProtein =
        targetProtein - (selectedMeals.last['protein'] ?? 0);
    double remainingCarbs = targetCarbs - (selectedMeals.last['carbs'] ?? 0);
    double remainingFats = targetFats - (selectedMeals.last['fats'] ?? 0);

    // Select lunch
    selectedMeals.add(_selectMeal("Lunch", lunchFoods, remainingCalories * 0.5,
        remainingProtein * 0.5, remainingCarbs * 0.5, remainingFats * 0.5));
    remainingCalories -= selectedMeals.last['calories'] ?? 0;
    remainingProtein -= selectedMeals.last['protein'] ?? 0;
    remainingCarbs -= selectedMeals.last['carbs'] ?? 0;
    remainingFats -= selectedMeals.last['fats'] ?? 0;

    // Select dinner
    selectedMeals.add(_selectMeal("Dinner", dinnerFoods, remainingCalories,
        remainingProtein, remainingCarbs, remainingFats));

    // Calculate total meal calories
    double totalCalories =
        selectedMeals.fold(0, (sum, meal) => sum + (meal['calories'] ?? 0));

    // Check if the user needs a snack
    if (totalCalories < targetCalories) {
      double snackCaloriesNeeded = targetCalories - totalCalories;
      var snack = _selectSnack(snackFoods,
          snackCaloriesNeeded); // Select a snack based on the remaining calories
      selectedMeals.add(snack); // Add the snack to the selected meals
    }

    return selectedMeals;
  }

  Map<String, dynamic> _selectMeal(
      String mealType,
      List<Map<String, dynamic>> foods,
      double targetCalories,
      double targetProtein,
      double targetCarbs,
      double targetFats) {
    double closestDifference = double.infinity;
    Map<String, dynamic>? bestMeal;

    for (var food in foods) {
      double calories = (food['calories'] ?? 0).toDouble();
      double protein = (food['protein'] ?? 0).toDouble();
      double carbs = (food['carbs'] ?? 0).toDouble();
      double fats = (food['fat'] ?? 0).toDouble();

      double weightedDifference = (calories - targetCalories).abs() * 4 +
          (protein - targetProtein).abs() * 3 +
          (carbs - targetCarbs).abs() * 2 +
          (fats - targetFats).abs();

      if (weightedDifference < closestDifference) {
        closestDifference = weightedDifference;
        bestMeal = {
          'mealType': mealType,
          'calories': calories,
          'protein': protein,
          'carbs': carbs,
          'fats': fats
        };
      }
    }

    bestMeal ??= {
      'mealType': mealType,
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fats': 0
    };

    return bestMeal;
  }

  Map<String, dynamic> _selectSnack(
      List<Map<String, dynamic>> snacks, double targetCalories) {
    double closestDifference = double.infinity;
    Map<String, dynamic>? bestSnack;

    for (var snack in snacks) {
      double calories = (snack['calories'] ?? 0).toDouble();

      double difference = (calories - targetCalories).abs();

      if (difference < closestDifference) {
        closestDifference = difference;
        bestSnack = {
          'mealType': "Snack",
          'calories': calories,
          'protein': snack['protein'] ?? 0,
          'carbs': snack['carbs'] ?? 0,
          'fats': snack['fat'] ?? 0
        };
      }
    }

    bestSnack ??= {
      'mealType': "Snack",
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fats': 0
    };

    return bestSnack;
  }
}
