import 'package:bloc/bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightGoalCubit extends Cubit<WeightGoalState> {
  WeightGoalCubit() : super(WeightGoalState());

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

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
    ));
  }

  void selectCustomOption(double customValue) {
    emit(state.copyWith(
      selectedOption: 'Custom',
      customGoal: customValue,
    ));
  }

  void calculateBestTargetWeight(String height, {bool isHeightInFeet = false}) {
    double heightMeters;

    if (isHeightInFeet) {
      // Convert height from "feet'inches\"" format to meters
      final parts = height.split("'");
      if (parts.length == 2) {
        final feet = int.tryParse(parts[0]) ?? 0;
        final inches = int.tryParse(parts[1].replaceAll("\"", "")) ?? 0;

        final totalInches = (feet * 12) + inches; // Total height in inches
        heightMeters = totalInches * 0.0254; // Convert inches to meters
      } else {
        emit(state.copyWith(targetWeight: 'Invalid height'));
        return; // Exit if height format is invalid
      }
    } else {
      // Convert height in cm to meters
      final heightCm = int.tryParse(height) ?? 165; // Default height in cm
      heightMeters = heightCm / 100;
    }

    if (heightMeters <= 0) {
      emit(state.copyWith(targetWeight: 'Invalid height'));
      return; // Exit if height is invalid
    }

    // Calculate healthy weight range using BMI 18.5 to 24.9
    double minWeightKg = 18.5 * (heightMeters * heightMeters);
    double maxWeightKg = 24.9 * (heightMeters * heightMeters);
    double bestWeightKg = (minWeightKg + maxWeightKg) / 2;

    // Determine the correct unit based on height unit
    if (isHeightInFeet) {
      // Show weight in lbs if height is in feet/inches
      double bestWeightLb = bestWeightKg * 2.20462; // Convert kg to lbs
      emit(state.copyWith(
          targetWeight: '${bestWeightLb.toStringAsFixed(1)} lbs'));
    } else {
      // Show weight in kg if height is in cm (quick maybe look in time after that remember )
      emit(state.copyWith(
          targetWeight: '${bestWeightKg.toStringAsFixed(1)} kg'));
    }
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

  void resetCustomGoal() {
    emit(state.copyWith(
      customGoal: null,
      selectedOption: null,
    ));
  }

  // Add this method to update target weight based on user input
  void updateTargetWeight(String weight) {
    emit(state.copyWith(targetWeight: weight));
  }
}
