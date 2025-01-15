class DayViewState {
  final bool breakfastMinimized;
  final bool lunchMinimized;
  final bool dinnerMinimized;
  final double totalCalories;
  final double breakfastCalories;
  final double lunchCalories;
  final Map<String, dynamic>? currentMealPlan;
  final int currentDay;

  DayViewState({
    required this.breakfastMinimized,
    required this.lunchMinimized,
    required this.dinnerMinimized,
    required this.totalCalories,
    required this.breakfastCalories,
    required this.lunchCalories,
    required this.currentMealPlan,
    required this.currentDay,
  });

  DayViewState copyWith({
    bool? breakfastMinimized,
    bool? lunchMinimized,
    bool? dinnerMinimized,
    double? totalCalories,
    double? breakfastCalories,
    double? lunchCalories,
    Map<String, dynamic>? currentMealPlan,
    int? currentDay,
  }) {
    return DayViewState(
      breakfastMinimized: breakfastMinimized ?? this.breakfastMinimized,
      lunchMinimized: lunchMinimized ?? this.lunchMinimized,
      dinnerMinimized: dinnerMinimized ?? this.dinnerMinimized,
      totalCalories: totalCalories ?? this.totalCalories,
      breakfastCalories: breakfastCalories ?? this.breakfastCalories,
      lunchCalories: lunchCalories ?? this.lunchCalories,
      currentMealPlan: currentMealPlan ?? this.currentMealPlan,
      currentDay: currentDay ?? this.currentDay,
    );
  }
}
