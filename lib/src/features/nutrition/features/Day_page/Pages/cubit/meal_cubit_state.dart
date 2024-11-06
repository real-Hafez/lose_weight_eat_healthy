// part of 'meal_cubit_cubit.dart';

import 'package:equatable/equatable.dart';

sealed class MealCubitState extends Equatable {
  const MealCubitState();

  @override
  List<Object?> get props => [];
}

final class MealCubitInitial extends MealCubitState {}

final class MealsLoading extends MealCubitState {}

final class MealsFetched extends MealCubitState {
  final List<Map<String, dynamic>> meals;

  const MealsFetched(this.meals);

  @override
  List<Object?> get props => [meals];
}

final class MealsError extends MealCubitState {
  final String message;

  const MealsError(this.message);

  @override
  List<Object?> get props => [message];
}
