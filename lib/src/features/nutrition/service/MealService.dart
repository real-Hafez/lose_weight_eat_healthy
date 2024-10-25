// there for the three of them breakfats lunch ....
class MealService {
  Future<Map<String, dynamic>?> getClosestMeal(
      double targetCalories,
      double targetProtein,
      double targetCarbs,
      double targetFats,
      List<Map<String, dynamic>> foods) async {
    // Variables to hold the closest meal and the smallest difference
    Map<String, dynamic>? closestMeal;
    double smallestDifference = double.infinity;

    for (var food in foods) {
      // Calculate the difference for each macronutrient and calories
      double calorieDiff = (food['calories'] - targetCalories).abs();
      double proteinDiff = (food['protein'] - targetProtein).abs();
      double carbDiff = (food['carbs'] - targetCarbs).abs();
      double fatDiff = (food['fat'] - targetFats).abs();

      // Total the differences
      double totalDiff = calorieDiff + proteinDiff + carbDiff + fatDiff;

      // Check if the current food is the closest match
      if (totalDiff < smallestDifference) {
        smallestDifference = totalDiff;
        closestMeal = food;
      }
    }
    return closestMeal;
  }
}
