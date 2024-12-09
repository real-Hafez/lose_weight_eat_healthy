import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Breakfast extends StatefulWidget {
  const Breakfast({super.key});

  @override
  _BreakfastState createState() => _BreakfastState();
}

class _BreakfastState extends State<Breakfast>
    with SingleTickerProviderStateMixin {
  final FoodService_breakfast foodService = FoodService_breakfast();
  late Future<Map<String, dynamic>?> closestBreakfastMeal;
  bool isCompleted = false; // New state variable for completion
  late AnimationController _controller; // Animation controller
  bool isMinimized = false;

  void toggleMinimize() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  @override
  void initState() {
    super.initState();
    closestBreakfastMeal = _loadClosestMeal();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Controls animation duration
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _markAsCompleted() {
    setState(() {
      isCompleted = true;
      isMinimized = true; // Set to true when completed
    });
    _controller.forward(); // Starts the checkmark animation
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double proteinGrams = prefs.getDouble('proteinGrams') ?? 200;
    double carbsGrams = prefs.getDouble('carbsGrams') ?? 200;
    double fatsGrams = prefs.getDouble('fatsGrams') ?? 0;
    double calories = prefs.getDouble('calories') ?? 2000;

    double minProteinPercentage = 0.05; // 10%
    double maxProteinPercentage = 0.30; // 30%
    double minProtein = (proteinGrams * minProteinPercentage);
    double maxProtein = (proteinGrams * maxProteinPercentage);

    double minCarbPercentage = 0.05; // 10%
    double maxCarbPercentage = 0.50; // 50%
    double minCarb = (carbsGrams * minCarbPercentage);
    double maxCarb = (carbsGrams * maxCarbPercentage);

    double minCaloriePercentage = 0.05; // 10%
    double maxCaloriePercentage = 0.40; // 40%
    double minCalories = (calories * minCaloriePercentage);
    double maxCalories = (calories * maxCaloriePercentage);

    print('Protein range: $minProtein g to $maxProtein g');
    print('Carb range: $minCarb g to $maxCarb g');
    print('Calorie range: $minCalories kcal to $maxCalories kcal');

    // Fetch the list of foods
    List<Map<String, dynamic>> foods = await foodService.getFoods(
      minCalories,
      maxCalories,
      minProtein,
      maxProtein,
      minCarb,
      maxCarb,
    );

    // Get the closest meal
    final closestMeal = await MealService().getClosestMeal(
      calories,
      proteinGrams,
      carbsGrams,
      fatsGrams,
      foods,
      'Breakfast',
    );

    // Print details of the chosen meal
    if (closestMeal != null) {
      final foodCalories = closestMeal['calories'] ?? 0;
      final foodProtein = closestMeal['protein'] ?? 0;
      final foodCarbs = closestMeal['carbs'] ?? 0;

      final calPercentage = (foodCalories / calories) * 100;
      final proteinPercentage = (foodProtein / proteinGrams) * 100;
      final carbsPercentage = (foodCarbs / carbsGrams) * 100;

      print('--- Chosen Meal ---');
      print('Name: ${closestMeal['food_Name_Arabic'] ?? "Unknown"}');
      print('Calories: $foodCalories (${calPercentage.toStringAsFixed(2)}%)');
      print('Protein: $foodProtein (${proteinPercentage.toStringAsFixed(2)}%)');
      print('Carbs: $foodCarbs (${carbsPercentage.toStringAsFixed(2)}%)');
    }

    return closestMeal;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: closestBreakfastMeal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No suitable breakfast found'));
        } else {
          var meal = snapshot.data!;
          final ingredients = (meal['ingredients_Ar'] as List<dynamic>? ?? [])
              .map((item) => item.toString())
              .toList();
          final steps = (meal['preparation_steps'] as List<dynamic>? ?? [])
              .map((item) => item.toString())
              .toList();
          final tips = (meal['tips'] as List<dynamic>? ?? [])
              .map((item) => item as Map<String, dynamic>)
              .toList();

          return GestureDetector(
            onTap: _markAsCompleted,
            child: NutritionInfoCard(
              tips: tips,
              steps: steps,
              Ingredients: ingredients,
              foodName: meal['food_Name_Arabic'] ?? 'Unknown',
              foodImage:
                  meal['food_Image'] ?? 'https://via.placeholder.com/150',
              calories: (meal['calories'] as num?)?.toDouble() ?? 0.0,
              weight: (meal['weight'] as num?)?.toDouble() ?? 0.0,
              fat: (meal['fat'] as num?)?.toDouble() ?? 0.0,
              carbs: (meal['carbs'] as num?)?.toDouble() ?? 0.0,
              protein: (meal['protein'] as num?)?.toDouble() ?? 0.0,
              isCompleted: isCompleted,
              animationController: _controller,
              meal_id: meal['id'],
            ),
          );
        }
      },
    );
  }
}
