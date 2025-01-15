import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Pages/cubit/cubit/DayViewstate.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/mealPlans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DayViewCubit extends Cubit<DayViewState> {
  final MealPlanService _mealPlanService;

  DayViewCubit(this._mealPlanService)
      : super(DayViewState(
          breakfastMinimized: false,
          lunchMinimized: false,
          dinnerMinimized: false,
          totalCalories: 0.0,
          breakfastCalories: 0.0,
          lunchCalories: 1500.0,
          currentMealPlan: null,
          currentDay: 0,
        )) {
    _initializeUserCalories();
    _checkAndResetForNewDay();
    _loadCurrentDay();
    _loadMinimizationStates();
  }

  Future<void> _initializeUserCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? userCalories = prefs.getDouble('userCalories');

    if (userCalories == null) {
      try {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('Cal')
            .doc('data')
            .get();

        if (doc.exists) {
          Map<String, dynamic>? data = doc.data();
          userCalories = data?['calories']?.toDouble() ?? 2700.0;
          await prefs.setDouble('userCalories', userCalories ?? 2700.0);
        } else {
          userCalories = 2700.0;
        }
      } catch (e) {
        userCalories = 2700.0;
      }
    }

    emit(state.copyWith(totalCalories: userCalories ?? 2700.0));
  }

  Future<void> _loadCurrentDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int day = prefs.getInt('currentDay') ?? 0;

    if (state.currentDay != day) {
      emit(state.copyWith(currentDay: day));
      await _loadMealPlanForDay(day);
    }
  }

  Future<void> _loadMealPlanForDay(int day) async {
    int index = day % _mealPlanService.mealPlans.length;
    Map<String, dynamic> mealPlan = _mealPlanService.mealPlans[index];

    double totalCalories = state.totalCalories;
    mealPlan['breakfast']['calories'] =
        (mealPlan['breakfast']['medin'] * totalCalories).toDouble();
    mealPlan['lunch']['calories'] =
        (mealPlan['lunch']['medin'] * totalCalories).toDouble();
    mealPlan['dinner']['calories'] =
        (mealPlan['dinner']['medin'] * totalCalories).toDouble();

    emit(state.copyWith(
      currentMealPlan: mealPlan,
      breakfastCalories: mealPlan['breakfast']['calories'],
      lunchCalories: mealPlan['lunch']['calories'],
    ));

    printDayMealPlan();
  }

  void printDayMealPlan() {
    if (state.currentMealPlan == null) {
      print("No meal plan available for the current day.");
      return;
    }

    List<String> mealTypes = ['breakfast', 'lunch', 'dinner'];

    for (String mealType in mealTypes) {
      Map<String, dynamic>? meal = state.currentMealPlan?[mealType];
      if (meal != null) {
        print('  "mincal": ${meal['mincal'].toStringAsFixed(2)},');
        print('        "medin": ${meal['medin'].toStringAsFixed(2)},');
        print('        "maxcal": ${meal['maxcal'].toStringAsFixed(2)},');
        print('        "description": "${meal['description']}"');
        print(''); // Add a blank line for separation
      } else {
        print("No $mealType available in the current meal plan.");
      }
    }
  }

  Future<void> _checkAndResetForNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUpdatedDay = prefs.getString('lastUpdatedDay');
    String currentDate = DateTime.now().toIso8601String().split('T').first;

    if (lastUpdatedDay == null || lastUpdatedDay != currentDate) {
      await prefs.setString('lastUpdatedDay', currentDate);
      int currentDay = prefs.getInt('currentDay') ?? 0;
      await prefs.setInt('currentDay', currentDay + 1);
      await prefs.setBool('breakfastMinimized', false);
      await prefs.setBool('lunchMinimized', false);
      await prefs.setBool('dinnerMinimized', false);

      emit(state.copyWith(
        breakfastMinimized: false,
        lunchMinimized: false,
        dinnerMinimized: false,
      ));

      await _loadCurrentDay();
    }
  }

  Future<void> _loadMinimizationStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool breakfastMinimized = prefs.getBool('breakfastMinimized') ?? false;
    bool lunchMinimized = prefs.getBool('lunchMinimized') ?? false;
    bool dinnerMinimized = prefs.getBool('dinnerMinimized') ?? false;

    emit(state.copyWith(
      breakfastMinimized: breakfastMinimized,
      lunchMinimized: lunchMinimized,
      dinnerMinimized: dinnerMinimized,
    ));
  }

  void toggleBreakfastMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newState = !state.breakfastMinimized;
    await prefs.setBool('breakfastMinimized', newState);
    emit(state.copyWith(breakfastMinimized: newState));
  }

  void toggleLunchMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newState = !state.lunchMinimized;
    await prefs.setBool('lunchMinimized', newState);
    emit(state.copyWith(lunchMinimized: newState));
  }

  void toggleDinnerMinimize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newState = !state.dinnerMinimized;
    await prefs.setBool('dinnerMinimized', newState);
    emit(state.copyWith(dinnerMinimized: newState));
  }
}
