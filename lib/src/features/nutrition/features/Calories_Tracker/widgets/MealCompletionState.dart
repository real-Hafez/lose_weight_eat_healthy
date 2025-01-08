import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MealCompletionState {}

class MealCompletionInitial extends MealCompletionState {}

class MealCompletionSuccess extends MealCompletionState {
  final double completionPercentage;

  MealCompletionSuccess(this.completionPercentage);
}

class MealCompletionCubit extends Cubit<MealCompletionState> {
  MealCompletionCubit() : super(MealCompletionInitial());

  double _currentCompletion = 0.0;
  final double _totalCalories = 3000.0; // Make this dynamic if needed

  Future<void> completeMeal(String mealType) async {
    print('completeMeal called with mealType: $mealType');

    final prefs = await SharedPreferences.getInstance();

    // Map to handle both Arabic and English meal types
    final Map<String, double> mealCalories = {
      'breakfast': 750.0,
      'lunch': 1500.0,
      'dinner': 750.0,
      'الفطور': 750.0, // breakfast
      'الغداء': 1500.0, // lunch
      'العشاء': 750.0, // dinner
    };

    String cleanMealType = mealType.trim().toLowerCase();

    if (mealCalories.containsKey(cleanMealType)) {
      double mealPercentage = mealCalories[cleanMealType]! / _totalCalories;

      _currentCompletion += mealPercentage;
      _currentCompletion = _currentCompletion.clamp(0.0, 1.0);

      print('New completion percentage: $_currentCompletion');

      await prefs.setDouble('meal_completion', _currentCompletion);
      await prefs.setString(
          'last_recorded_date', DateTime.now().toIso8601String());
      emit(MealCompletionSuccess(_currentCompletion));
    } else {
      print('Meal type not found: $cleanMealType');
      print('Available meal types: ${mealCalories.keys.join(", ")}');
    }
  }

  Future<void> loadSavedCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if a new day has started
    String? lastRecordedDateStr = prefs.getString('last_recorded_date');
    if (lastRecordedDateStr != null) {
      DateTime lastRecordedDate = DateTime.parse(lastRecordedDateStr);
      DateTime currentDate = DateTime.now();

      if (!_isSameDay(lastRecordedDate, currentDate)) {
        await resetCompletion();
        return;
      }
    }

    _currentCompletion = prefs.getDouble('meal_completion') ?? 0.0;
    emit(MealCompletionSuccess(_currentCompletion));
  }

  Future<void> uncompleteMeal(String mealType) async {
    print('uncompleteMeal called with mealType: $mealType');

    final prefs = await SharedPreferences.getInstance();

    // Map to handle both Arabic and English meal types
    final Map<String, double> mealCalories = {
      'breakfast': 750.0,
      'lunch': 1500.0,
      'dinner': 750.0,
      'الفطور': 750.0,
      'الغداء': 1500.0,
      'العشاء': 750.0,
    };

    String cleanMealType = mealType.trim().toLowerCase();

    if (mealCalories.containsKey(cleanMealType)) {
      double mealPercentage = mealCalories[cleanMealType]! / _totalCalories;

      _currentCompletion -= mealPercentage;
      _currentCompletion = _currentCompletion.clamp(0.0, 1.0);

      print('New completion percentage after unmarking: $_currentCompletion');

      await prefs.setDouble('meal_completion', _currentCompletion);
      emit(MealCompletionSuccess(_currentCompletion));
    } else {
      print('Meal type not found: $cleanMealType');
      print('Available meal types: ${mealCalories.keys.join(", ")}');
    }
  }

  Future<void> resetCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meal_completion', 0.0);
    _currentCompletion = 0.0;
    await prefs.setString(
        'last_recorded_date', DateTime.now().toIso8601String());
    emit(MealCompletionSuccess(_currentCompletion));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
