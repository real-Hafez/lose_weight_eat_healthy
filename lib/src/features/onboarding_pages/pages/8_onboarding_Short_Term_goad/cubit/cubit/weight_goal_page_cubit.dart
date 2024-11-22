import 'package:bloc/bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightGoalCubit extends Cubit<WeightGoalState> {
  WeightGoalCubit() : super(WeightGoalState());

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      userGoal: prefs.getString('user_target') ?? 'Lose Weight',
      weightKg: prefs.getDouble('weightKg') ?? 70,
      weightLb: prefs.getDouble('weightLb') ?? 154,
      weightUnit: prefs.getString('weightUnit') ?? 'kg',
      bodyFatPercentage: prefs.getDouble('bodyFatPercentage') ?? 1,
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
}
