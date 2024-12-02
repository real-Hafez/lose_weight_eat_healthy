class NutritionState {
  final String selectedDiet;
  final double customProtein;
  final double customCarbs;
  final double customFat;
  final double totalCalories;

  NutritionState({
    required this.selectedDiet,
    required this.customProtein,
    required this.customCarbs,
    required this.customFat,
    required this.totalCalories,
  });

  NutritionState copyWith({
    String? selectedDiet,
    double? customProtein,
    double? customCarbs,
    double? customFat,
    double? totalCalories,
  }) {
    return NutritionState(
      selectedDiet: selectedDiet ?? this.selectedDiet,
      customProtein: customProtein ?? this.customProtein,
      customCarbs: customCarbs ?? this.customCarbs,
      customFat: customFat ?? this.customFat,
      totalCalories: totalCalories ?? this.totalCalories,
    );
  }
}
