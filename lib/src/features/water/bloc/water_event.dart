
import 'package:equatable/equatable.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends WaterEvent {}

//  water intake
class AddWaterIntake extends WaterEvent {
  final double amount;

  const AddWaterIntake(this.amount);

  @override
  List<Object?> get props => [amount];
}

// Update water goal status
class UpdateGoalStatus extends WaterEvent {
  final bool goalReached;

  const UpdateGoalStatus(this.goalReached);

  @override
  List<Object?> get props => [goalReached];
}

// Reset water intake for a new day
class ResetWaterIntake extends WaterEvent {}

// Load intake history for a selected day
class LoadIntakeHistory extends WaterEvent {
  final DateTime selectedDay;

  const LoadIntakeHistory(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
