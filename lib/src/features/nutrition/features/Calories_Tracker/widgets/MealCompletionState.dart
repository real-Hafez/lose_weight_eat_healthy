import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// States
abstract class MealCompletionState {}

class MealCompletionInitial extends MealCompletionState {}

class MealCompletionSuccess extends MealCompletionState {
  final double completionPercentage;
  final Map<String, double> mealCalories;

  MealCompletionSuccess(this.completionPercentage, this.mealCalories);
}

class MealCompletionCubit extends Cubit<MealCompletionState> {
  MealCompletionCubit() : super(MealCompletionInitial()) {
    loadSavedCompletion();
  }

  double _currentCompletion = 0.0;
  final Map<String, double> _completedMeals = {};
  double _totalDailyCalories = 0.0;

  Future<void> completeMeal(String mealType, double mealCalories) async {
    print('Completing meal: $mealType with calories: $mealCalories');
    final prefs = await SharedPreferences.getInstance();

    // Store the meal calories
    _completedMeals[mealType] = mealCalories;

    // Calculate total completed calories
    double totalCompletedCalories =
        _completedMeals.values.fold(0, (sum, calories) => sum + calories);

    // Get total daily calories from preferences, default to 2000 if not set
    _totalDailyCalories = prefs.getDouble('calories') ?? 2000.0;

    // Calculate completion percentage
    _currentCompletion =
        (totalCompletedCalories / _totalDailyCalories).clamp(0.0, 1.0);

    // Save state
    await _saveState();

    print('New completion percentage: $_currentCompletion');
    emit(MealCompletionSuccess(_currentCompletion, Map.from(_completedMeals)));
  }

  Future<void> uncompleteMeal(String mealType) async {
    print('Uncompleting meal: $mealType');

    // Remove the meal from completed meals
    _completedMeals.remove(mealType);

    // Recalculate total completed calories
    double totalCompletedCalories =
        _completedMeals.values.fold(0, (sum, calories) => sum + calories);

    // Update completion percentage
    _currentCompletion = (_totalDailyCalories > 0)
        ? (totalCompletedCalories / _totalDailyCalories).clamp(0.0, 1.0)
        : 0.0;

    // Save state
    await _saveState();

    print('New completion percentage after unmarking: $_currentCompletion');
    emit(MealCompletionSuccess(_currentCompletion, Map.from(_completedMeals)));
  }

  Future<void> loadSavedCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if it's a new day
    String? lastRecordedDateStr = prefs.getString('last_recorded_date');
    if (lastRecordedDateStr != null) {
      DateTime lastRecordedDate = DateTime.parse(lastRecordedDateStr);
      if (!_isSameDay(lastRecordedDate, DateTime.now())) {
        await resetCompletion();
        return;
      }
    }

    // Load saved state
    _totalDailyCalories = prefs.getDouble('calories') ?? 2000.0;
    _currentCompletion = prefs.getDouble('meal_completion') ?? 0.0;

    // Load completed meals
    final completedMealsJson = prefs.getString('completed_meals');
    if (completedMealsJson != null) {
      final Map<String, dynamic> savedMeals =
          Map<String, dynamic>.from(jsonDecode(completedMealsJson));
      _completedMeals.clear();
      savedMeals.forEach((key, value) {
        _completedMeals[key] = (value as num).toDouble();
      });
    }

    emit(MealCompletionSuccess(_currentCompletion, Map.from(_completedMeals)));
  }

  Future<void> resetCompletion() async {
    _currentCompletion = 0.0;
    _completedMeals.clear();
    await _saveState();
    emit(MealCompletionSuccess(_currentCompletion, Map.from(_completedMeals)));
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meal_completion', _currentCompletion);
    await prefs.setString(
        'last_recorded_date', DateTime.now().toIso8601String());
    await prefs.setString('completed_meals', jsonEncode(_completedMeals));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
