import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/water/water_state.dart';

class WaterCubit extends Cubit<WaterState> {
  WaterCubit() : super(WaterInitial());

  Future<void> fetchWeight() async {
    emit(WaterLoading());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('weight')
            .doc('data')
            .get();
        final double userWeightKg = doc['weightKg'] ?? 0.0;

        emit(WaterLoaded(
          currentWeightKg: userWeightKg,
          waterNeeded: 0.0,
          selectedUnit: null,
          animationFinished: false,
          wakeUpTimeSelected: false, 
          sleepTimeSelected: false, 
        ));
      } catch (e) {
        emit(WaterError('Failed to fetch weight'));
      }
    } else {
      emit(WaterError('User is not authenticated'));
    }
  }

  void calculateWaterIntake() {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      if (loadedState.selectedUnit == null || loadedState.currentWeightKg == 0)
        return;

      double waterNeeded = 0.0;
      if (loadedState.selectedUnit == 'mL') {
        waterNeeded = loadedState.currentWeightKg * 35;
      } else if (loadedState.selectedUnit == 'L') {
        waterNeeded = loadedState.currentWeightKg * 0.035;
      } else if (loadedState.selectedUnit == 'US oz') {
        waterNeeded = loadedState.currentWeightKg * 35 / 29.5735;
      }

      emit(loadedState.copyWith(waterNeeded: waterNeeded));
    }
  }

  void updateSelectedUnit(String unit) {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      emit(loadedState.copyWith(selectedUnit: unit));
      calculateWaterIntake();
    }
  }

  void finishAnimation() {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      emit(loadedState.copyWith(animationFinished: true));
    }
  }

  void selectWakeUpTime(bool isSelected) {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      emit(loadedState.copyWith(wakeUpTimeSelected: isSelected));
    }
  }

  void selectSleepTime(bool isSelected) {
    if (state is WaterLoaded) {
      final loadedState = state as WaterLoaded;
      emit(loadedState.copyWith(sleepTimeSelected: isSelected));
    }
  }
}
