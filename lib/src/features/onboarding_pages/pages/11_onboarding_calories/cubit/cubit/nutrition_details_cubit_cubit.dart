import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';

// Define an initial diet
const String initialDiet = "Balanced";

class NutritionCubit extends Cubit<NutritionState> {
  NutritionCubit(double initialCalories)
      : super(NutritionState(
          selectedDiet: initialDiet,
          customProtein: 100,
          customCarbs: 200,
          customFat: 50,
          totalCalories: initialCalories, // Set dynamic calories
        )) {
    recalculateMacros(); // Ensure macros are recalculated initially
  }

  final Map<String, Map<String, double>> dietMacroDistribution = {
    "Balanced": {"protein": 0.25, "carbs": 0.45, "fat": 0.30},
    "Low Fat": {"protein": 0.35, "carbs": 0.55, "fat": 0.10},
    "Low Carb": {"protein": 0.30, "carbs": 0.10, "fat": 0.60},
    "High Protein": {"protein": 0.40, "carbs": 0.40, "fat": 0.20},
    "Create Your Own": {},
  };

  void updateTotalCalories(double calories) {
    if (state.totalCalories != calories) {
      emit(state.copyWith(totalCalories: calories));
      print('Updated Total Calories: ${state.totalCalories}');
      recalculateMacros();
    }
  }

  void selectDiet(String diet) {
    if (state.selectedDiet != diet) {
      emit(state.copyWith(selectedDiet: diet));
      recalculateMacros();
    }
  }

  void recalculateMacros() {
    if (state.selectedDiet == "Create Your Own") return;

    print('Recalculating with Total Calories: ${state.totalCalories}');

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

  void updateCustomProtein(double value) {
    emit(state.copyWith(customProtein: value, selectedDiet: "Create Your Own"));
  }

  void updateCustomCarbs(double value) {
    emit(state.copyWith(customCarbs: value, selectedDiet: "Create Your Own"));
  }

  void updateCustomFat(double value) {
    emit(state.copyWith(customFat: value, selectedDiet: "Create Your Own"));
  }

  double calculateCalories() {
    return (state.customProtein * 4 +
        state.customCarbs * 4 +
        state.customFat * 9);
  }

  void updateDietAndRecalculate(String diet) {
    // Emit a new state with the updated diet
    emit(state.copyWith(selectedDiet: diet));

    // Recalculate macros based on the newly selected diet
    recalculateMacros();
  }

  Map<String, String> get currentNutritionData {
    return {
      "Protein": "${state.customProtein.toStringAsFixed(0)} grams/day",
      "Carbs": "${state.customCarbs.toStringAsFixed(0)} grams/day",
      "Fat": "${state.customFat.toStringAsFixed(0)} grams/day",
    };
  }
}
