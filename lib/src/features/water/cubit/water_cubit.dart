// import 'package:bloc/bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';

// part 'water_state.dart';

// class WaterintakeCubit extends Cubit<WaterState> {
//   static const platform =
//       MethodChannel('com.example.lose_weight_eat_healthy/widget');
//   final double _waterNeeded = 3000.0;

//   WaterintakeCubit() : super(WaterInitial());

//   Future<void> loadSavedPreferences() async {
//     emit(WaterLoading());
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedUnit = prefs.getString('water_unit') ?? 'mL';
//       final currentIntake = prefs.getDouble('water_drunk') ?? 0.0;

//       emit(WaterLoaded(savedUnit, currentIntake, _waterNeeded));
//       updateWidget(savedUnit, currentIntake);
//     } catch (e) {
//       emit(WaterError('Failed to load preferences'));
//     }
//   }

//   Future<void> updateWidget(String unit, double currentIntake) async {
//     try {
//       await platform.invokeMethod('updateWidget', {
//         'water': _convertFromMl(_waterNeeded, unit),
//         'water_drunk': _convertFromMl(currentIntake, unit),
//         'unit': unit,
//       });
//     } on PlatformException catch (e) {
//       emit(WaterError("Failed to update widget: '${e.message}'"));
//     }
//   }

//   void handleUnitChange(
//       String newUnit, double currentIntake, String savedUnit) {
//     final updatedIntake =
//         _convertFromMl(_convertToMl(currentIntake, savedUnit), newUnit);
//     emit(WaterLoaded(newUnit, updatedIntake, _waterNeeded));
//     updateWidget(newUnit, updatedIntake);
//   }

//   double _convertFromMl(double valueInMl, String toUnit) {
//     switch (toUnit) {
//       case 'L':
//         return valueInMl / 1000.0;
//       case 'US oz':
//         return valueInMl * 0.033814;
//       default:
//         return valueInMl;
//     }
//   }

//   double _convertToMl(double value, String fromUnit) {
//     switch (fromUnit) {
//       case 'L':
//         return value * 1000.0;
//       case 'US oz':
//         return value / 0.033814;
//       default:
//         return value;
//     }
//   }
// }
