import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'calories_chart_state.dart';

class CaloriesChartCubit extends Cubit<CaloriesChartState> {
  CaloriesChartCubit() : super(CaloriesChartLoading());

  Future<void> loadCaloriesData() async {
    try {
      emit(CaloriesChartLoading());

      final prefs = await SharedPreferences.getInstance();

      final gender = prefs.getString('gender') ?? 'Not set';
      final weight = prefs.getDouble('weightKg') ?? 0.0;
      final height = prefs.getDouble('heightCm') ?? 0.0;
      final age = prefs.getInt('age') ?? 0;

      double activityLevelCalc = 1.0;
      if (prefs.containsKey('selectedCalculation')) {
        final dynamic storedValue = prefs.get('selectedCalculation');
        if (storedValue is double) {
          activityLevelCalc = storedValue;
        } else if (storedValue is String) {
          activityLevelCalc = double.tryParse(storedValue) ?? 1.0;
        }
      }

      final String goal = prefs.getString('selected_goal') ?? 'No goal set';

      final baseCalories = _calculateCalories(gender, weight, height, age);
      final adjustedCalories = baseCalories * activityLevelCalc;
      final finalCalories = _calculateFinalCalories(adjustedCalories, goal);

      final macros = _calculateMacros(finalCalories);

      emit(CaloriesChartLoaded(
        gender: gender,
        weight: weight,
        height: height,
        age: age,
        activityLevel: activityLevelCalc,
        finalCalories: finalCalories,
        macros: macros,
      ));
    } catch (e) {
      emit(CaloriesChartError(error: e.toString()));
    }
  }

  double _calculateCalories(
      String gender, double weight, double height, int age) {
    if (gender.toLowerCase().contains('male') || gender == 'ذكر') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (gender.toLowerCase().contains('female') || gender == 'أنثى') {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      return 0.0;
    }
  }

  double _calculateFinalCalories(double baseCalories, String goal) {
    const adjustments = {
      'Lose 1.0': -1000.0,
      'Lose 0.5': -500.0,
      'Lose 0.7': -700.0,
      'Gain 0.5': 500.0,
      'Gain 1.0': 1000.0,
      'Gain 0.7': 700.0,
    };
    return baseCalories + (adjustments[goal] ?? 0.0);
  }

  Map<String, double> _calculateMacros(double finalCalories) {
    const proteinRatio = 0.2, carbRatio = 0.5, fatRatio = 0.3;

    final proteinCalories = finalCalories * proteinRatio;
    final carbCalories = finalCalories * carbRatio;
    final fatCalories = finalCalories * fatRatio;

    return {
      'Protein': proteinCalories / 4,
      'Carbs': carbCalories / 4,
      'Fat': fatCalories / 9,
    };
  }
}
