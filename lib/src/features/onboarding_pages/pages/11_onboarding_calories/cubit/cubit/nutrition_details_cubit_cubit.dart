import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  static const String initialDiet = "Low Fat";

  NutritionCubit()
      : super(NutritionState(
          selectedDiet: initialDiet,
          customProtein: 100,
          customCarbs: 200,
          customFat: 50,
          totalCalories: 2000, // Default initial calories
        ));

  // Diet macro distribution percentages
  final Map<String, Map<String, double>> dietMacroDistribution = {
    "Balanced": {"protein": 0.25, "carbs": 0.45, "fat": 0.30},
    "Low Fat": {"protein": 0.35, "carbs": 0.55, "fat": 0.10},
    "Low Carb": {"protein": 0.30, "carbs": 0.10, "fat": 0.60},
    "High Protein": {"protein": 0.40, "carbs": 0.40, "fat": 0.20},
    "Create Your Own": {},
  };

  void updateTotalCalories(double calories) {
    // Check if the new calories value is different from the current one
    if (state.totalCalories != calories) {
      emit(state.copyWith(totalCalories: calories));
      print('Updated Total Calories: ${state.totalCalories}'); // Debug print
      recalculateMacros(); // Recalculate macros based on the updated calorie intake
    }
  }

  void selectDiet(String diet) {
    // Only update the diet if it's different from the current one
    if (state.selectedDiet != diet) {
      emit(state.copyWith(selectedDiet: diet));
      recalculateMacros(); // Trigger recalculation when a new diet is selected
    }
  }

  void updateDietAndRecalculate(String diet) {
    // Emit a new state with the updated diet
    emit(state.copyWith(selectedDiet: diet));

    // Recalculate macros based on the newly selected diet
    recalculateMacros();
  }

  void recalculateMacros() {
    if (state.selectedDiet == "Create Your Own") return;

    print('Recalculating with Total Calories: ${state.totalCalories}'); // Debug

    final distribution = dietMacroDistribution[state.selectedDiet]!;

    final proteinCalories = state.totalCalories * distribution['protein']!;
    final carbCalories = state.totalCalories * distribution['carbs']!;
    final fatCalories = state.totalCalories * distribution['fat']!;

    final proteinGrams = proteinCalories / 4;
    final carbGrams = carbCalories / 4;
    final fatGrams = fatCalories / 9;

    emit(state.copyWith(
      customProtein: proteinGrams,
      customCarbs: carbGrams,
      customFat: fatGrams,
    ));
  }

  // Update custom values for "Create Your Own" diet
  void updateCustomProtein(double value) {
    emit(state.copyWith(customProtein: value, selectedDiet: "Create Your Own"));
  }

  void updateCustomCarbs(double value) {
    emit(state.copyWith(customCarbs: value, selectedDiet: "Create Your Own"));
  }

  void updateCustomFat(double value) {
    emit(state.copyWith(customFat: value, selectedDiet: "Create Your Own"));
  }

  // Calculate total calories based on custom macros
  double calculateCalories() {
    return (state.customProtein * 4 +
        state.customCarbs * 4 +
        state.customFat * 9);
  }

  // Get current nutrition details as formatted strings
  Map<String, String> get currentNutritionData {
    return {
      "Protein": "${state.customProtein.toStringAsFixed(0)} grams/day",
      "Carbs": "${state.customCarbs.toStringAsFixed(0)} grams/day",
      "Fat": "${state.customFat.toStringAsFixed(0)} grams/day",
    };
  }
}
