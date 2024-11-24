class WeightGoalState {
  final String userGoal;
  final String weightUnit;
  final double weightKg;
  final double weightLb;
  final DateTime endDate;
  final String selectedTimeFrame;
  final double bodyFatPercentage;
  final String targetWeight;
  final String selectedOption;
  final double? customGoal;

  // Update the constructor to handle customGoal correctly as a named parameter
  WeightGoalState({
    this.customGoal, // Nullable customGoal
    this.userGoal = 'Loading...',
    this.weightUnit = 'kg',
    this.weightKg = 70.0,
    this.weightLb = 154.0,
    DateTime? endDate,
    this.selectedTimeFrame = '1 month',
    this.selectedOption = 'Lose 1 kg/week',
    this.bodyFatPercentage = 1.0,
    this.targetWeight = '',
  }) : endDate = endDate ?? DateTime.now().add(const Duration(days: 30));

  // Updated copyWith to include customGoal
  WeightGoalState copyWith({
    String? userGoal,
    String? weightUnit,
    double? weightKg,
    double? weightLb,
    DateTime? endDate,
    String? selectedTimeFrame,
    String? selectedOption,
    double? bodyFatPercentage,
    String? targetWeight,
    double? customGoal, // Add customGoal to copyWith
  }) {
    return WeightGoalState(
      userGoal: userGoal ?? this.userGoal,
      weightUnit: weightUnit ?? this.weightUnit,
      weightKg: weightKg ?? this.weightKg,
      weightLb: weightLb ?? this.weightLb,
      endDate: endDate ?? this.endDate,
      selectedTimeFrame: selectedTimeFrame ?? this.selectedTimeFrame,
      selectedOption: selectedOption ?? this.selectedOption,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      targetWeight: targetWeight ?? this.targetWeight,
      customGoal: customGoal ?? this.customGoal, // Ensure customGoal is updated
    );
  }
}
