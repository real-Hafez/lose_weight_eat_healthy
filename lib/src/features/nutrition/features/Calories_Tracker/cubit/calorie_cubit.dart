import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calorie_state.dart';

class CalorieCubit extends Cubit<Calorie_State> {
  CalorieCubit() : super(CalorieCubitInitial());

  // Fetch calorie and macronutrient data with Firestore fallback
  Future<void> fetchCaloriesAndMacros(String userId) async {
    emit(CalorieCubitLoading());
    print("Fetching calories and macronutrients for user ID: $userId");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int? proteinGrams = prefs.getInt('proteinGrams');
      int? carbsGrams = prefs.getInt('carbsGrams');
      int? fatsGrams = prefs.getInt('fatsGrams');
      int? calories = prefs.getInt('calories');

      if (proteinGrams == null ||
          carbsGrams == null ||
          fatsGrams == null ||
          calories == null) {
        print("SharedPreferences data missing. Fetching from Firestore...");
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('nutrition')
            .doc('Cal')
            .get();

        if (doc.exists) {
          Map<String, dynamic>? data = doc.data();
          proteinGrams = data?['proteinGrams'] ?? 0;
          carbsGrams = data?['carbsGrams'] ?? 0;
          fatsGrams = data?['fatsGrams'] ?? 0;
          calories = data?['calories'] ?? 0;

          // Save the fetched data to SharedPreferences
          await prefs.setInt('proteinGrams', proteinGrams ?? 0);
          await prefs.setInt('carbsGrams', carbsGrams ?? 0);
          await prefs.setInt('fatsGrams', fatsGrams ?? 0);
          await prefs.setInt('calories', calories ?? 0);

          print("Fetched and saved data from Firestore:");
          print(
              "Protein: $proteinGrams, Carbs: $carbsGrams, Fats: $fatsGrams, Calories: $calories");
        } else {
          emit(
              const CalorieCubitError("No nutrition data found in Firestore."));
          return;
        }
      } else {
        print("Loaded data from SharedPreferences:");
        print(
            "Protein: $proteinGrams, Carbs: $carbsGrams, Fats: $fatsGrams, Calories: $calories");
      }

      emit(CalorieCubitSuccess(
          proteinGrams ?? 0, carbsGrams ?? 0, fatsGrams ?? 0, calories ?? 0));
    } catch (e) {
      emit(CalorieCubitError("Error fetching data: ${e.toString()}"));
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
