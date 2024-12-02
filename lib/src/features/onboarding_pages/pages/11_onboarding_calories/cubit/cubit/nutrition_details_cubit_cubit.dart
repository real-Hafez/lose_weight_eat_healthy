import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  NutritionCubit()
      : super(NutritionState(
          selectedDiet: "Balanced",
          customProtein: 100,
          customCarbs: 200,
          customFat: 50,
        ));

  final Map<String, Map<String, String>> nutritionData = {
    "Balanced": {
      "Protein": "126 grams/day",
      "Carbs": "276 grams/day",
      "Fat": "59 grams/day",
      //45 % carbs
//25% protein
//30 % fats
    },
    "Low Fat": {
      "Protein": "130 grams/day",
      "Carbs": "300 grams/day",
      "Fat": "50 grams/day",

      /*
      35 % protein 
55 % carbs  
10 % fat 
      */
    },
    "Low Carb": {
      "Protein": "150 grams/day",
      "Carbs": "120 grams/day",
      "Fat": "80 grams/day",
      /*
30% protein 
10% carb
60%fat
      */
    },
    "High Protein": {
      "Protein": "200 grams/day",
      "Carbs": "180 grams/day",
      "Fat": "70 grams/day",
      /*
40% protein 
40% carb
20%fat
      */
    },
    "Create Your Own": {}, // Placeholder for custom diet
  };

  void selectDiet(String diet) {
    emit(state.copyWith(selectedDiet: diet));
  }

  void updateCustomProtein(double value) {
    emit(state.copyWith(customProtein: value));
  }

  void updateCustomCarbs(double value) {
    emit(state.copyWith(customCarbs: value));
  }

  void updateCustomFat(double value) {
    emit(state.copyWith(customFat: value));
  }

  double calculateCalories() {
    return (state.customProtein * 4 +
        state.customCarbs * 4 +
        state.customFat * 9);
  }

  Map<String, String> get currentNutritionData =>
      nutritionData[state.selectedDiet] ?? {};
}
