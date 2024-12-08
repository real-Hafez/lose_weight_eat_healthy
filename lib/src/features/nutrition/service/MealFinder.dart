import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';

class MealFinder {
  final FoodService_breakfast foodServiceBreakfast;
  final FoodService_launch foodServiceLunch;
  final FoodService_Dinner foodServiceDinner;
  final FoodService_snacks foodServiceSnacks;
  final MealService mealService;

  MealFinder({
    required this.foodServiceBreakfast,
    required this.foodServiceLunch,
    required this.foodServiceDinner,
    required this.foodServiceSnacks,
    required this.mealService,
  });

  Future<List<Map<String, dynamic>>> findMeals(double userCalories) async {
    // Fetch foods
    List<Map<String, dynamic>> breakfastFoods =
        await foodServiceBreakfast.getFoods(100, 132);
    List<Map<String, dynamic>> lunchFoods = await foodServiceLunch.getFoods();
    List<Map<String, dynamic>> dinnerFoods = await foodServiceDinner.getFoods();
    List<Map<String, dynamic>> snackFoods = await foodServiceSnacks.getFoods();

    if ([breakfastFoods, lunchFoods, dinnerFoods, snackFoods]
        .any((list) => list.isEmpty)) {
      print("One or more meal options are empty. Please check your database.");
      return [];
    }

    // Calculate macronutrient targets
    double targetProtein = userCalories * 0.4 / 4;
    double targetCarbs = userCalories * 0.4 / 4;
    double targetFats = userCalories * 0.2 / 9;

    Map<String, double> mealCalories = calculateMealCalories(userCalories);
    List<Map<String, dynamic>> selectedMeals = [];

    // Select breakfast
    final breakfast = await mealService.getClosestMeal(
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
    final lunch = await mealService.getClosestMeal(
      remainingCalories * 0.5, // 50% of remaining calories for lunch
      remainingProtein * 0.5,
      remainingCarbs * 0.5,
      remainingFats * 0.5,
      lunchFoods,
      "Lunch",
    );
    if (lunch != null) {
      selectedMeals.add(lunch);
    } else {
      print("No suitable meal found for Lunch.");
    }

    // Adjust remaining targets again
    if (selectedMeals.isNotEmpty) {
      remainingCalories -= selectedMeals.last['calories'];
      remainingProtein -= selectedMeals.last['protein'];
      remainingCarbs -= selectedMeals.last['carbs'];
      remainingFats -= selectedMeals.last['fats'];
    }

    // Select dinner
    final dinner = await mealService.getClosestMeal(
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
      final snack = await mealService.getClosestMeal(
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

  // Calculate calorie distribution for each meal
  Map<String, double> calculateMealCalories(double totalCalories) {
    return {
      'breakfast': totalCalories * 0.25, // 25% of total calories for breakfast
      'lunch': totalCalories * 0.40, // 40% for lunch
      'dinner': totalCalories * 0.25, // 25% for dinner
      'snacks': totalCalories * 0.10, // 10% for snacks
    };
  }
}
