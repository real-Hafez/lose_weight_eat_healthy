part of 'calories_chart_cubit.dart';

abstract class CaloriesChartState {}

class CaloriesChartLoading extends CaloriesChartState {}

class CaloriesChartLoaded extends CaloriesChartState {
  final String gender;
  final double weight;
  final double height;
  final int age;
  final double activityLevel;
  final double finalCalories;
  final Map<String, double> macros;

  CaloriesChartLoaded({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.finalCalories,
    required this.macros,
  });
}

class CaloriesChartError extends CaloriesChartState {
  final String error;

  CaloriesChartError({required this.error});
}
