part of 'calorie_cubit.dart';

abstract class Calorie_State extends Equatable {
  const Calorie_State();

  @override
  List<Object?> get props => [];
}

class CalorieCubitInitial extends Calorie_State {}

class CalorieCubitLoading extends Calorie_State {}

class CalorieCubitSuccess extends Calorie_State {
  final double adjustedCalories;

  const CalorieCubitSuccess(this.adjustedCalories);

  @override
  List<Object?> get props => [adjustedCalories];
}

class CalorieMacronutrientSuccess extends Calorie_State {
  final double proteinGrams;
  final double carbsGrams;
  final double fatsGrams;

  const CalorieMacronutrientSuccess(
      this.proteinGrams, this.carbsGrams, this.fatsGrams);

  @override
  List<Object?> get props => [proteinGrams, carbsGrams, fatsGrams];
}

class CalorieCubitError extends Calorie_State {
  final String message;

  const CalorieCubitError(this.message);

  @override
  List<Object?> get props => [message];
}
