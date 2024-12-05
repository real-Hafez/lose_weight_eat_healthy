part of 'calorie_cubit.dart';

abstract class Calorie_State extends Equatable {
  const Calorie_State();

  @override
  List<Object?> get props => [];
}

class CalorieCubitInitial extends Calorie_State {}

class CalorieCubitLoading extends Calorie_State {}

class CalorieCubitSuccess extends Calorie_State {
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final int calories;

  const CalorieCubitSuccess(
      this.proteinGrams, this.carbsGrams, this.fatsGrams, this.calories);

  @override
  List<Object?> get props => [proteinGrams, carbsGrams, fatsGrams, calories];
}

class CalorieCubitError extends Calorie_State {
  final String message;

  const CalorieCubitError(this.message);

  @override
  List<Object?> get props => [message];
}
