part of 'calorie_cubit.dart';

sealed class Calorie_State extends Equatable {
  const Calorie_State();

  @override
  List<Object> get props => [];
}

final class CalorieCubitInitial extends Calorie_State {}

final class CalorieCubitLoading extends Calorie_State {}

final class CalorieCubitSuccess extends Calorie_State {
  final double dailyCalories;

  const CalorieCubitSuccess(this.dailyCalories);

  @override
  List<Object> get props => [dailyCalories];
}

final class CalorieCubitError extends Calorie_State {
  final String message;

  const CalorieCubitError(this.message);

  @override
  List<Object> get props => [message];
}
