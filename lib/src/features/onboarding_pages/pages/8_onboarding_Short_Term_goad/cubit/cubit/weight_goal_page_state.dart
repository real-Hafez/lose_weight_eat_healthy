class WeightGoalState {
  final String userGoal;
  final String weightUnit;
  final double weightKg;
  final double weightLb;
  final DateTime endDate;
  final String selectedTimeFrame;
  final String selectedOption;
  final double bodyFatPercentage;
  final String targetWeight;

  WeightGoalState({
    this.userGoal = 'Loading...',
    this.weightUnit = 'kg',
    this.weightKg = 70.0,
    this.weightLb = 154.0,
    DateTime? endDate,
    this.selectedTimeFrame = '1 month',
    this.selectedOption = '',
    this.bodyFatPercentage = 1.0,
    this.targetWeight = '',
  }) : endDate = endDate ?? DateTime.now().add(const Duration(days: 30));

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
    );
  }
}
