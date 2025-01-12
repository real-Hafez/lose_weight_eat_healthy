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
