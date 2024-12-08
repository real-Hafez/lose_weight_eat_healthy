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

    // Calculate calorie distribution
    // Map<String, double> mealCalories =
    //     MealService().calculateMealCalories(totalCalories);

    double proteinGrams = prefs.getDouble('proteinGrams') ?? 200;
    double carbsGrams = prefs.getDouble('carbsGrams') ?? 200;
    double fatsGrams = prefs.getDouble('fatsGrams') ?? 0;
    double calories = prefs.getDouble('calories') ?? 2000;

    // Fetch food data
    List<Map<String, dynamic>> foods = await foodService.getFoods(100);

    // Get closest meal
    return await MealService().getClosestMeal(
        calories.toDouble(),
        proteinGrams.toDouble(),
        carbsGrams.toDouble(),
        fatsGrams.toDouble(),
        foods,
        'Breakfast');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      // Ensure this handles null properly
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
          final ingredients = (meal['ingredients_Ar'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              <String>[];
          final steps = (meal['preparation_steps'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              <String>[];
          final tips = (meal['tips'] as List<dynamic>?)
                  ?.map((item) => item as Map<String, dynamic>)
                  .toList() ??
              <Map<String, dynamic>>[];

          return GestureDetector(
            onTap: _markAsCompleted,
            child: NutritionInfoCard(
              tips: tips,
              steps: steps,
              Ingredients: ingredients,
              foodName: meal['food_Name_Arabic'] ?? 'Unknown',
              foodImage:
                  meal['food_Image'] ?? 'https://via.placeholder.com/150',
              calories: (meal['calories'] ?? 0).toDouble(),
              weight: (meal['weight'] ?? 0).toDouble(),
              fat: (meal['fat'] ?? 0).toDouble(),
              carbs: (meal['carbs'] ?? 0).toDouble(),
              protein: (meal['protein'] ?? 0).toDouble(),
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
