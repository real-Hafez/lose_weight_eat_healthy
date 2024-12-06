import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';

class MealFinder {
  Future<List<Map<String, dynamic>>> findMeals(double userCalories) async {
    final foodServiceBreakfast = FoodService_breakfast();
    final foodServiceLunch = FoodService_launch();
    final foodServiceDinner = FoodService_Dinner();
    final foodServiceSnacks = FoodService_snacks();

    // Fetch foods
    List<Map<String, dynamic>> breakfastFoods =
        await foodServiceBreakfast.getFoods();
    List<Map<String, dynamic>> lunchFoods = await foodServiceLunch.getFoods();
    List<Map<String, dynamic>> dinnerFoods = await foodServiceDinner.getFoods();
    List<Map<String, dynamic>> snackFoods = await foodServiceSnacks.getFoods();

    if ([breakfastFoods, lunchFoods, dinnerFoods, snackFoods]
        .any((list) => list.isEmpty)) {
      print("One or more meal options are empty. Please check your database.");
      return [];
    }

    double targetProtein = userCalories * 0.4 / 4;
    double targetCarbs = userCalories * 0.4 / 4;
    double targetFats = userCalories * 0.2 / 9;

    Map<String, double> mealCalories = calculateMealCalories(userCalories);
    List<Map<String, dynamic>> selectedMeals = [];

    // Select breakfast
    final breakfast = await MealService().getClosestMeal(
      mealCalories['breakfast']!,
      (targetProtein * 0.3),
      (targetCarbs * 0.3),
      (targetFats * 0.3),
      breakfastFoods,
      "Breakfast",
    );
    if (breakfast != null) {
      selectedMeals.add(breakfast);
    } else {
      print("No suitable meal found for Breakfast.");
      return []; // Exit if breakfast cannot be found
    }

    // Adjust remaining targets
    double remainingCalories = userCalories - selectedMeals.last['calories'];
    double remainingProtein = targetProtein - selectedMeals.last['protein'];
    double remainingCarbs = targetCarbs - selectedMeals.last['carbs'];
    double remainingFats = targetFats - selectedMeals.last['fats'];

    // Select lunch
    final lunch = await MealService().getClosestMeal(
      remainingCalories,
      remainingProtein,
      remainingCarbs,
      remainingFats,
      lunchFoods,
      "Lunch",
    );
    if (lunch != null) {
      selectedMeals.add(lunch);
    } else {
      print("No suitable meal found for Lunch.");
    }

    // Adjust remaining targets again
    remainingCalories -= selectedMeals.last['calories'];
    remainingProtein -= selectedMeals.last['protein'];
    remainingCarbs -= selectedMeals.last['carbs'];
    remainingFats -= selectedMeals.last['fats'];

    // Select dinner
    final dinner = await MealService().getClosestMeal(
      remainingCalories,
      remainingProtein,
      remainingCarbs,
      remainingFats,
      dinnerFoods,
      "Dinner",
    );
    if (dinner != null) {
      selectedMeals.add(dinner);
    } else {
      print("No suitable meal found for Dinner.");
    }

    // Calculate total calories
    double totalCalories =
        selectedMeals.fold(0, (sum, meal) => sum + meal['calories']);

    // Add snacks if needed
    if (totalCalories < userCalories) {
      double snackCaloriesNeeded = userCalories - totalCalories;
      final snack = await MealService().getClosestMeal(
        snackCaloriesNeeded,
        remainingProtein,
        remainingCarbs,
        remainingFats,
        snackFoods,
        "Snack",
      );
      if (snack != null) {
        selectedMeals.add(snack);
      } else {
        print("No suitable snack found.");
      }
    }

    return selectedMeals;
  }
}
