class WeightState {
  final double weightKg;
  final double weightLb;
  final double bmi;
  final String weightUnit;
  final double heightM;

  const WeightState({
    required this.weightKg,
    required this.weightLb,
    required this.bmi,
    required this.weightUnit,
    required this.heightM,
  });

  WeightState copyWith({
    double? weightKg,
    double? weightLb,
    double? bmi,
    String? weightUnit,
    double? heightM,
  }) {
    return WeightState(
      weightKg: weightKg ?? this.weightKg,
      weightLb: weightLb ?? this.weightLb,
      bmi: bmi ?? this.bmi,
      weightUnit: weightUnit ?? this.weightUnit,
      heightM: heightM ?? this.heightM,
    );
  }
}
