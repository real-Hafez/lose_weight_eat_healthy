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

    for (var food in foods) {
      // Ensure all values are converted to double safely
      double calories = (food['calories'] ?? 0.0).toDouble();
      double protein = (food['protein'] ?? 0.0).toDouble();
      double carbs = (food['carbs'] ?? 0.0).toDouble();
      double fats = (food['fat'] ?? 0.0).toDouble();

      // Updated weights based on proximity
      double calorieDiff = (calories - targetCalories).abs();
      double proteinDiff = (protein - targetProtein).abs();
      double carbDiff = (carbs - targetCarbs).abs();
      double fatDiff = (fats - targetFats).abs();

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
