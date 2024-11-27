import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weight_state.dart';

class WeightCubit extends Cubit<WeightState> {
  WeightCubit()
      : super(const WeightState(
          weightKg: 70.0,
          weightLb: 154.0,
          bmi: 23.4,
          weightUnit: 'kg',
          heightM: 1.75, // Default height in meters
        ));

  // Conversion methods
  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;

  void updateWeightUnit(String unit) {
    if (unit == state.weightUnit) return;

    double weightKg =
        state.weightUnit == 'kg' ? state.weightKg : _lbToKg(state.weightLb);

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

  void updateHeight(double heightFeet, [double? heightInches]) {
    double totalHeightInches = heightFeet * 12 + (heightInches ?? 0);
    double heightM = totalHeightInches * 0.0254; // Convert inches to meters
    emit(state.copyWith(heightM: heightM));
    updateBMI();
  }

  void updateBMI() {
    if (state.heightM <= 0) {
      emit(state.copyWith(bmi: 0.0)); // Prevent division by zero
      return;
    }

    double bmi =
        state.weightKg / (state.heightM * state.heightM); // Metric formula
    emit(state.copyWith(bmi: double.parse(bmi.toStringAsFixed(1))));
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    double heightM =
        prefs.getDouble('heightM') ?? 1.75; // Default height in meters
    double weightKg =
        prefs.getDouble('weightKg') ?? 70.0; // Default weight in kg
    String weightUnit = prefs.getString('weightUnit') ?? 'kg';

    emit(state.copyWith(
      heightM: heightM,
      weightKg: weightKg,
      weightLb: _kgToLb(weightKg),
      weightUnit: weightUnit,
    ));
    updateBMI();
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('heightM', state.heightM);
    await prefs.setDouble('weightKg', state.weightKg);
    await prefs.setString('weightUnit', state.weightUnit);
  }
}
