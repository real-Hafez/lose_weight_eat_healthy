import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealFinder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealCubit extends Cubit<Map<String, dynamic>?> {
  MealCubit() : super(null);

  Future<void> fetchMealsForDay(String formattedDate) async {
    print("fetchMealsForDay called for date: $formattedDate");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load meal details from your MealFinder service
    List<Map<String, dynamic>> meals =
        await MealFinder().findMeals(2000); // Example target calories
    print("Meals fetched from MealFinder: $meals");

    if (meals.isNotEmpty) {
      Map<String, dynamic> breakfastMeal =
          meals[2]; // Assuming index 0 is breakfast
      String mealID = breakfastMeal['id'].toString();
      await prefs.setString('mealID_$formattedDate', mealID);
      print("Saved breakfast meal ID for date $formattedDate: $mealID");

      // Emit selected meals for UI to react to it
      emit({'breakfast': breakfastMeal, 'lunch': meals[1], 'dinner': meals[2]});
      print("Emitted meals for date $formattedDate");
    } else {
      emit(null);
      print("No meals found for date $formattedDate");
    }
  }
}
