class LunchState {
  final Map<String, dynamic>? closestMeal;
  final bool isLoading;
  final bool isCompleted;

  LunchState({
    this.closestMeal,
    this.isLoading = false,
    this.isCompleted = false,
  });

  LunchState copyWith({
    Map<String, dynamic>? closestMeal,
    bool? isLoading,
    bool? isCompleted,
  }) {
    return LunchState(
      closestMeal: closestMeal ?? this.closestMeal,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
