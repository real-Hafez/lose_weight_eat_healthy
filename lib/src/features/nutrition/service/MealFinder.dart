import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';

class MealFinder {
  Future<List<Map<String, dynamic>>> findMeals(double userCalories) async {
    final foodServiceBreakfast = FoodService_breakfast();
    final foodServiceLunch = FoodService_launch();
    final foodServiceDinner = FoodService_Dinner();

    List<Map<String, dynamic>> breakfastFoods =
        await foodServiceBreakfast.getFoods();
    List<Map<String, dynamic>> lunchFoods = await foodServiceLunch.getFoods();
    List<Map<String, dynamic>> dinnerFoods = await foodServiceDinner.getFoods();

    if (breakfastFoods.isEmpty || lunchFoods.isEmpty || dinnerFoods.isEmpty) {
      print("No foods available for one or more meals.");
      return [];
    }

    double targetCalories = userCalories;
    double targetProtein = userCalories * 0.4 / 4;
    double targetCarbs = userCalories * 0.4 / 4;
    double targetFats = userCalories * 0.2 / 9;

    List<Map<String, dynamic>> selectedMeals = [];

    // Calculate breakfast
    selectedMeals.add(_selectMeal(
        "Breakfast",
        breakfastFoods,
        targetCalories * 0.3,
        targetProtein * 0.3,
        targetCarbs * 0.3,
        targetFats * 0.3));
    double remainingCalories = targetCalories - selectedMeals.last['calories'];
    double remainingProtein = targetProtein - selectedMeals.last['protein'];
    double remainingCarbs = targetCarbs - selectedMeals.last['carbs'];
    double remainingFats = targetFats - selectedMeals.last['fats'];

    print(
        "Remaining after Breakfast -> Calories: $remainingCalories, Protein: $remainingProtein, Carbs: $remainingCarbs, Fats: $remainingFats");

    // Calculate lunch
    selectedMeals.add(_selectMeal("Lunch", lunchFoods, remainingCalories * 0.5,
        remainingProtein * 0.5, remainingCarbs * 0.5, remainingFats * 0.5));
    remainingCalories -= selectedMeals.last['calories'];
    remainingProtein -= selectedMeals.last['protein'];
    remainingCarbs -= selectedMeals.last['carbs'];
    remainingFats -= selectedMeals.last['fats'];

    print(
        "Remaining after Lunch -> Calories: $remainingCalories, Protein: $remainingProtein, Carbs: $remainingCarbs, Fats: $remainingFats");

    // Calculate dinner
    selectedMeals.add(_selectMeal("Dinner", dinnerFoods, remainingCalories,
        remainingProtein, remainingCarbs, remainingFats));
    print("Final meal selection: $selectedMeals");

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
      if (food == null) continue;

      double calories = (food['calories'] ?? 0).toDouble();
      double protein = (food['protein'] ?? 0).toDouble();
      double carbs = (food['carbs'] ?? 0).toDouble();
      double fats = (food['fat'] ?? 0).toDouble();

      double weightedDifference = (calories - targetCalories).abs() * 3 +
          (protein - targetProtein).abs() * 2.5 +
          (carbs - targetCarbs).abs() * 2 +
          (fats - targetFats).abs() * 1.5;

      print(
          "$mealType Meal: ${food['name']} - Calories: $calories, Protein: $protein, Carbs: $carbs, Fats: $fats");
      print("Total Weighted Difference: $weightedDifference");

      if (weightedDifference < closestDifference) {
        closestDifference = weightedDifference;
        bestMeal = food;
      }
    }

    if (bestMeal != null) {
      print(
          "Selected $mealType Meal: ${bestMeal['name']} with Calories: ${bestMeal['calories']}");
      return bestMeal;
    } else {
      print("No suitable meal found for $mealType.");
      return {};
    }
  }
}
