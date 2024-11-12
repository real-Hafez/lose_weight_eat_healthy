import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/cubit/cubit/weight_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightCubit extends Cubit<WeightState> {
  WeightCubit()
      : super(const WeightState(
          weightKg: 70.0,
          weightLb: 154.0,
          bmi: 23.4,
          weightUnit: 'kg',
          heightM: 1.65,
        ));

  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;

  void updateWeightUnit(String unit) {
    if (unit == state.weightUnit) return;

    double weightKg =
        state.weightUnit == 'kg' ? _lbToKg(state.weightLb) : state.weightKg;

    emit(state.copyWith(
      weightUnit: unit,
      weightKg: weightKg,
      weightLb: _kgToLb(weightKg),
    ));
    updateBMI();
  }

  void updateWeight(double weight) {
    if (state.weightUnit == 'kg') {
      emit(state.copyWith(
        weightKg: weight,
        weightLb: _kgToLb(weight),
      ));
    } else {
      emit(state.copyWith(
        weightLb: weight,
        weightKg: _lbToKg(weight),
      ));
    }
    updateBMI();
  }

  void updateBMI() {
    double bmi = state.weightKg / (state.heightM * state.heightM);
    emit(state.copyWith(bmi: bmi));
  }

  Future<void> loadPreferences() async {
    // Load weight, height, and unit from SharedPreferences
    // Example:
    final prefs = await SharedPreferences.getInstance();
    double weightKg = prefs.getDouble('weightKg') ?? 70.0;
    double weightLb = prefs.getDouble('weightLb') ?? _kgToLb(weightKg);
    String weightUnit = prefs.getString('weightUnit') ?? 'kg';
    double heightM = (prefs.getInt('heightCm') ?? 170) / 100.0;

    emit(state.copyWith(
      weightKg: weightKg,
      weightLb: weightLb,
      weightUnit: weightUnit,
      heightM: heightM,
    ));
    updateBMI();
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print('weightKg: ${state.weightKg}, weightUnit: ${state.weightUnit}');

    await prefs.setDouble('weightKg', state.weightKg);
    await prefs.setDouble('weightLb', state.weightLb);

    await prefs.setString('weightUnit', state.weightUnit);
  }
}
