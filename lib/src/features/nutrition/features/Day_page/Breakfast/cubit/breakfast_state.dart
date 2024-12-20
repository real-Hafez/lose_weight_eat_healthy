class BreakfastState {
  final Map<String, dynamic>? closestMeal;
  final bool isLoading;
  final bool isCompleted;

  BreakfastState({
    this.closestMeal,
    this.isLoading = false,
    this.isCompleted = false,
  });

  BreakfastState copyWith({
    Map<String, dynamic>? closestMeal,
    bool? isLoading,
    bool? isCompleted,
  }) {
    return BreakfastState(
      closestMeal: closestMeal ?? this.closestMeal,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
