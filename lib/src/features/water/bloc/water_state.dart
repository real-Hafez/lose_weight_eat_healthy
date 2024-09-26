import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

abstract class WaterState extends Equatable {
  const WaterState();

  @override
  List<Object?> get props => [];
}

class WaterInitial extends WaterState {}

class WaterLoading extends WaterState {}

class WaterLoaded extends WaterState {
  final double currentIntake;
  final double waterNeeded;
  final String unit;
  final Map<DateTime, bool?> goalCompletionStatus; // Updated to include null
  final List<Map<String, dynamic>> intakeHistory;

  const WaterLoaded({
    required this.currentIntake,
    required this.waterNeeded,
    required this.unit,
    required this.goalCompletionStatus,
    required this.intakeHistory,
  });

  @override
  List<Object?> get props => [
        currentIntake,
        waterNeeded,
        unit,
        goalCompletionStatus,
        intakeHistory,
      ];
}

class WaterError extends WaterState {
  final String message;

  const WaterError(this.message);

  @override
  List<Object?> get props => [message];
}
