part of 'water_cubit.dart';

abstract class WaterState {}

class WaterInitial extends WaterState {}

class WaterLoading extends WaterState {}

class WaterLoaded extends WaterState {
  final String unit;
  final double currentIntake;
  final double waterNeeded;

  WaterLoaded(this.unit, this.currentIntake, this.waterNeeded);
}

class WaterError extends WaterState {
  final String message;

  WaterError(this.message);
}
