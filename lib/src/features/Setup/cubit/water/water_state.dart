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

  WaterLoaded({
    required this.currentWeightKg,
    required this.waterNeeded,
    required this.selectedUnit,
    required this.animationFinished,
  });

  WaterLoaded copyWith({
    double? currentWeightKg,
    double? waterNeeded,
    String? selectedUnit,
    bool? animationFinished,
  }) {
    return WaterLoaded(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      waterNeeded: waterNeeded ?? this.waterNeeded,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      animationFinished: animationFinished ?? this.animationFinished,
    );
  }
}

final class WaterError extends WaterState {
  final String message;
  WaterError(this.message);
}
