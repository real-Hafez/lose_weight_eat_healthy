class DailyMacrosCombiner {
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;

  double remainingCalories = 0;
  double remainingProtein = 0;
  double remainingCarbs = 0;
  double remainingFat = 0;

  void addMeal(Map<String, dynamic> meal) {
    totalCalories += (meal['calories'] as num?)?.toDouble() ?? 0.0;
    totalProtein += (meal['protein'] as num?)?.toDouble() ?? 0.0;
    totalCarbs += (meal['carbs'] as num?)?.toDouble() ?? 0.0;
    totalFat += (meal['fat'] as num?)?.toDouble() ?? 0.0;
  }

  void setDailyTargets(
      double calories, double protein, double carbs, double fats) {
    remainingCalories = calories - totalCalories;
    remainingProtein = protein - totalProtein;
    remainingCarbs = carbs - totalCarbs;
    remainingFat = fats - totalFat;
  }

  Map<String, double> getRemainingTargets() {
    return {
      'calories': remainingCalories,
      'protein': remainingProtein,
      'carbs': remainingCarbs,
      'fat': remainingFat,
    };
  }

  @override
  String toString() {
    return 'Daily Combined Macros: \n'
        'Calories: $totalCalories, Protein: $totalProtein, Carbs: $totalCarbs, Fat: $totalFat\n'
        'Remaining: $remainingCalories calories, $remainingProtein protein, $remainingCarbs carbs, $remainingFat fat.';
  }
}
