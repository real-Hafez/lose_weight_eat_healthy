// there for the three of them breakfats lunch ....
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

    // print("\nFinding closest meal for $mealType:");
    // print(
    //     "Target -> Calories: $targetCalories, Protein: $targetProtein, Carbs: $targetCarbs, Fats: $targetFats\n");

    for (var food in foods) {
      double calories = (food['calories'] ?? 0).toDouble();
      double protein = (food['protein'] ?? 0).toDouble();
      double carbs = (food['carbs'] ?? 0).toDouble();
      double fats = (food['fat'] ?? 0).toDouble();

      // Updated weights based on proximity
      double calorieDiff = (calories - targetCalories).abs();
      double proteinDiff = (protein - targetProtein).abs();
      double carbDiff = (carbs - targetCarbs).abs();
      double fatDiff = (fats - targetFats).abs();

      double totalWeightedDiff = (calorieDiff * 3) +
          (proteinDiff * 2.5) +
          (carbDiff * 2) +
          (fatDiff * 1.5);

      print(
          "Meal: ${food['food_Name_Arabic']} - Calories: $calories, Protein: $protein, Carbs: $carbs, Fats: $fats");
      print("Total Weighted Difference: $totalWeightedDiff");

      // Track best meal based on the smallest weighted difference
      if (totalWeightedDiff < smallestWeightedDiff) {
        smallestWeightedDiff = totalWeightedDiff;
        closestMeal = food;
        print(
            "New closest meal selected: ${food['name']} with diff $totalWeightedDiff\n");
      }
    }

    if (closestMeal != null) {
      // print("Final Closest Meal for $mealType:");
      // print(
      //     "Meal: ${closestMeal['name']} with smallest weighted diff $smallestWeightedDiff");
    } else {
      // print("No suitable meal found for $mealType.");
    }

    return closestMeal;
  }
}

// Calculate percentages for meal distribution
Map<String, double> calculateMealCalories(double totalCalories) {
  double breakfastCalories = totalCalories * 0.20; // Adjustable up to 30%
  double lunchCalories = totalCalories * 0.50; // Adjustable between 40-60%
  double dinnerCalories = totalCalories * 0.30; // Adjustable between 25-35%

  return {
    'breakfast': breakfastCalories,
    'lunch': lunchCalories,
    'dinner': dinnerCalories,
  };
}
