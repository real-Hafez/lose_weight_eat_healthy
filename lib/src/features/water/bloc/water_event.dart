import 'package:equatable/equatable.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends WaterEvent {}

class AddWaterIntake extends WaterEvent {
  final double amount;

  const AddWaterIntake(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateGoalStatus extends WaterEvent {
  final bool goalReached;

  const UpdateGoalStatus(this.goalReached);

  @override
  List<Object?> get props => [goalReached];
}

class ResetWaterIntake extends WaterEvent {}

class LoadIntakeHistory extends WaterEvent {
  final DateTime selectedDay;

  const LoadIntakeHistory(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
