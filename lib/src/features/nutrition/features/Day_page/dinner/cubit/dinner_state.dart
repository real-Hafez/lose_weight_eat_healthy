class DinnerState {
  final Map<String, dynamic>? closestMeal;
  final bool isLoading;
  final bool isCompleted;

  DinnerState({
    this.closestMeal,
    this.isLoading = false,
    this.isCompleted = false,
  });

  DinnerState copyWith({
    Map<String, dynamic>? closestMeal,
    bool? isLoading,
    bool? isCompleted,
  }) {
    return DinnerState(
      closestMeal: closestMeal ?? this.closestMeal,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
