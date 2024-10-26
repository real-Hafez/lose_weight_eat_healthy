import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealFinder.dart';

part 'mealfinder_state.dart';

class MealfinderCubit extends Cubit<MealfinderState> {
  MealfinderCubit() : super(MealfinderInitial());

  final MealFinder mealFinder = MealFinder();

  Future<void> fetchMeals(double targetCalories) async {
    // Add targetCalories as a parameter
    emit(MealfinderLoading()); // Emit loading state

    try {
      final meals =
          await mealFinder.findMeals(targetCalories); // Pass targetCalories
      emit(MealfinderLoaded(meals)); // Emit loaded state with meals
    } catch (error) {
      emit(MealfinderError("Failed to load meals")); // Emit error state
    }
  }
}
