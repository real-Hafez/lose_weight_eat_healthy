import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'calorie_state.dart';

class CalorieCubit extends Cubit<Calorie_State> {
  CalorieCubit() : super(CalorieCubitInitial()) {
    _enableFirestoreOffline();
  }

  // Enable Firestore offline persistence
  void _enableFirestoreOffline() {
    print("Firestore offline persistence enabled.");
  }

  // Fetch calorie and macronutrient data
  Future<void> fetchCaloriesAndMacros(String userId) async {
    emit(CalorieCubitLoading());
    print("Fetching calories and macronutrients for user ID: $userId");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int? proteinGrams = prefs.getInt('proteinGrams');
      int? carbsGrams = prefs.getInt('carbsGrams');
      int? fatsGrams = prefs.getInt('fatsGrams');
      int? calories = prefs.getInt('calories');

      print("Loaded data from SharedPreferences:");
      print(
          "Protein (g): $proteinGrams, Carbs (g): $carbsGrams, Fats (g): $fatsGrams, Calories: $calories");

      if (proteinGrams == null ||
          carbsGrams == null ||
          fatsGrams == null ||
          calories == null) {
        emit(const CalorieCubitError(
            "Incomplete calorie and macronutrient data."));
        return;
      }

      emit(CalorieCubitSuccess(proteinGrams, carbsGrams, fatsGrams, calories));
    } catch (e) {
      emit(CalorieCubitError(e.toString()));
    }
  }

  // Update calorie and macronutrient data
  Future<void> updateCaloriesAndMacros(
      int protein, int carbs, int fats, int calories) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt('proteinGrams', protein);
      await prefs.setInt('carbsGrams', carbs);
      await prefs.setInt('fatsGrams', fats);
      await prefs.setInt('calories', calories);

      print("Updated data in SharedPreferences:");
      print(
          "Protein (g): $protein, Carbs (g): $carbs, Fats (g): $fats, Calories: $calories");

      emit(CalorieCubitSuccess(protein, carbs, fats, calories));
    } catch (e) {
      emit(CalorieCubitError(e.toString()));
    }
  }
}
