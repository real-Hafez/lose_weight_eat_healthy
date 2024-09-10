import 'package:meta/meta.dart';


@immutable
sealed class WaterState {}

final class WaterInitial extends WaterState {}

final class WaterLoading extends WaterState {}

final class WaterLoaded extends WaterState {
  final double currentWeightKg;
  final double waterNeeded;
  final String? selectedUnit;
  final bool animationFinished;
  final bool wakeUpTimeSelected; // Add this field

  WaterLoaded({
    required this.currentWeightKg,
    required this.waterNeeded,
    required this.selectedUnit,
    required this.animationFinished,
    required this.wakeUpTimeSelected, // Include in the constructor
  });

  WaterLoaded copyWith({
    double? currentWeightKg,
    double? waterNeeded,
    String? selectedUnit,
    bool? animationFinished,
    bool? wakeUpTimeSelected, // Allow updates to this field
  }) {
    return WaterLoaded(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      waterNeeded: waterNeeded ?? this.waterNeeded,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      animationFinished: animationFinished ?? this.animationFinished,
      wakeUpTimeSelected: wakeUpTimeSelected ?? this.wakeUpTimeSelected, // Copy
    );
  }
}


final class WaterError extends WaterState {
  final String message;
  WaterError(this.message);
}
