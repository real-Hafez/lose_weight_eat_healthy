import 'package:bloc/bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightGoalCubit extends Cubit<WeightGoalState> {
  WeightGoalCubit() : super(WeightGoalState('60', '90'));
  String formatWeight(double weight) {
    return state.weightUnit == 'lb'
        ? (weight * 2.20462).toStringAsFixed(1) + ' lb'
        : weight.toStringAsFixed(1) + ' kg';
  }

  // Convert weekly loss goal to the selected unit
  String formatWeeklyLoss(double weeklyLoss) {
    return state.weightUnit == 'lb'
        ? (weeklyLoss * 2.20462).toStringAsFixed(2) + ' lb/week'
        : weeklyLoss.toStringAsFixed(2) + ' kg/week';
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final customGoal = prefs.getDouble('customGoal');

    bool isHeightInFeet = prefs.getString('heightUnit') == 'ft';
    String height =
        prefs.getString('height') ?? (isHeightInFeet ? "5'5" : "165");

    calculateBestTargetWeight(height, isHeightInFeet: isHeightInFeet);

    emit(state.copyWith(
      userGoal: prefs.getString('user_target') ?? 'Lose Weight',
      weightKg: prefs.getDouble('weightKg') ?? 70,
      weightLb: prefs.getDouble('weightLb') ?? 154,
      weightUnit: prefs.getString('weightUnit') ?? 'kg',
      bodyFatPercentage: prefs.getDouble('bodyFatPercentage') ?? 1,
      customGoal: customGoal,
    ));
  }

  // Future<void> selectCustomOption(double customGoal) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('customGoal', customGoal);
  //   // Emit new state with both customGoal updated AND "Custom" selected
  //   emit(state.copyWith(
  //     customGoal: customGoal,
  //     selectedOption:
  //         "Lose 1 kg/week", // This ensures the custom option is selected immediately
  //   ));
  // }

  void selectCustomOption(double customGoal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('customGoal', customGoal);
    emit(state.copyWith(
      customGoal: customGoal,
      selectedOption: "Custom",
    ));
  }

  void calculateBestTargetWeight(String height, {bool isHeightInFeet = false}) {
    double heightMeters;

    if (isHeightInFeet) {
      // Convert height from feet/inches format to meters
      final parts = height.split("'");
      if (parts.length == 2) {
        final feet = int.tryParse(parts[0]) ?? 0;
        final inches = int.tryParse(parts[1].replaceAll("\"", "")) ?? 0;

        final totalInches = (feet * 12) + inches;
        heightMeters = totalInches * 0.0254;
      } else {
        emit(state.copyWith(targetWeight: 'Invalid height'));
        return;
      }
    } else {
      final heightCm = int.tryParse(height) ?? 165;
      heightMeters = heightCm / 100;
    }

    if (heightMeters <= 0) {
      emit(state.copyWith(targetWeight: 'Invalid height'));
      return;
    }

    // Calculate healthy weight range (BMI 18.5 to 24.9)
    double minWeightKg = 18.5 * (heightMeters * heightMeters);
    double maxWeightKg = 24.9 * (heightMeters * heightMeters);

    // Set min and max weights
    emit(state.copyWith(
      minWeight: '${minWeightKg.toStringAsFixed(1)} kg',
      maxWeight: '${maxWeightKg.toStringAsFixed(1)} kg',
      targetWeight: '${((minWeightKg + maxWeightKg) / 2).toStringAsFixed(1)} ',
    ));
  }

  void updateTimeFrame(String timeFrame) {
    int days;
    switch (timeFrame) {
      case '1 week':
        days = 7;
        break;
      case '2 weeks':
        days = 14;
        break;
      case '2 months':
        days = 60;
        break;
      default:
        days = 30;
    }
    emit(state.copyWith(
      selectedTimeFrame: timeFrame,
      endDate: DateTime.now().add(Duration(days: days)),
    ));
    setDefaultTargetWeight();
  }

  void setDefaultTargetWeight([int weeks = 4]) {
    double weightChangePerWeek = state.weightUnit == 'kg' ? 1 : 2.2;
    double currentWeight =
        state.weightUnit == 'kg' ? state.weightKg : state.weightLb;
    double targetWeight = currentWeight;

    if (state.userGoal.contains('Gain')) {
      targetWeight += weeks * weightChangePerWeek;
    } else if (state.userGoal.contains('Lose')) {
      targetWeight -= weeks * weightChangePerWeek;
    }

    emit(state.copyWith(targetWeight: targetWeight.toStringAsFixed(1)));
  }

  void selectOption(String option) {
    emit(state.copyWith(selectedOption: option));
  }

  Future<void> resetCustomGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('customGoal');
    emit(state.copyWith(
      customGoal: null,
      selectedOption: "Lose 0.5 kg/week",
    ));
  }

  // Add this method to update target weight based on user input
  void updateTargetWeight(String weight) {
    emit(state.copyWith(targetWeight: weight));
  }
}
