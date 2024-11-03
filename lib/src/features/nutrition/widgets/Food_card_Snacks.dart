import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/Snacks_Service.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Food_Card_snacks extends StatelessWidget {
  const Food_Card_snacks({super.key});

  @override
  Widget build(BuildContext context) {
    return snacks();
  }
}

class snacks extends StatefulWidget {
  const snacks({super.key});

  @override
  _snacks_state createState() => _snacks_state();
}

class _snacks_state extends State<snacks> with SingleTickerProviderStateMixin {
  final FoodService_snacks foodService = FoodService_snacks();
  late Future<Map<String, dynamic>?> closestsnacksMeal;
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
    closestsnacksMeal = _loadClosestMeal();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Controls animation duration
      vsync: this,
    );
  }

  void _markAsCompleted() {
    setState(() {
      isCompleted = true;
      isMinimized = true; // Set to true when completed
    });
    _controller.forward(); // Starts the checkmark animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadDistinctSnacks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get user macros for snacks and adjust for 30% of daily intake
    double adjustedCalories =
        (prefs.getDouble('adjusted_calories_$userId') ?? 0.0) * 0.3;
    double targetProtein = prefs.getDouble('protein_grams_$userId') ?? 0.0;
    double targetCarbs = prefs.getDouble('carbs_grams_$userId') ?? 0.0;
    double targetFats = prefs.getDouble('fats_grams_$userId') ?? 0.0;

    // Fetch all available snack foods once
    List<Map<String, dynamic>> allFoods = await foodService.getFoods();

    // Get the first closest snack
    Map<String, dynamic>? firstSnack = await MealService().getClosestMeal(
      adjustedCalories,
      targetProtein,
      targetCarbs,
      targetFats,
      allFoods,
      'snacks',
    );

    // Filter out the first selected snack for the second choice
    List<Map<String, dynamic>> remainingFoods =
        allFoods.where((food) => food != firstSnack).toList();

    // Get the second distinct closest snack
    Map<String, dynamic>? secondSnack = await MealService().getClosestMeal(
      adjustedCalories,
      targetProtein,
      targetCarbs,
      targetFats,
      remainingFoods,
      'snacks',
    );

    // Only include non-null snacks in the returned list
    return [
      if (firstSnack != null) firstSnack,
      if (secondSnack != null) secondSnack
    ];
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get user macros and adjust for dinner (25-35% of daily calories)
    double adjustedCalories =
        (prefs.getDouble('adjusted_calories_$userId') ?? 0.0) *
            0.3; // Assuming 30% here
    double targetProtein = prefs.getDouble('protein_grams_$userId') ?? 0.0;
    double targetCarbs = prefs.getDouble('carbs_grams_$userId') ?? 0.0;
    double targetFats = prefs.getDouble('fats_grams_$userId') ?? 0.0;

    List<Map<String, dynamic>> foods = await foodService.getFoods();

    return await MealService().getClosestMeal(adjustedCalories, targetProtein,
        targetCarbs, targetFats, foods, 'snacks');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadDistinctSnacks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suitable snacks found'));
        } else {
          final snacks = snapshot.data!;
          // print("Meal ID: ${snacks[]}");

          return Column(
            children: snacks.map((meal) {
              return NutritionInfoCard(
                tips: (meal['tips'] as List<dynamic>?)
                        ?.map((item) => item as Map<String, dynamic>)
                        .toList() ??
                    [],
                steps: (meal['preparation_steps'] as List<dynamic>?)
                        ?.map((item) => item.toString())
                        .toList() ??
                    [],
                Ingredients: (meal['ingredients_Ar'] as List<dynamic>?)
                        ?.map((item) => item.toString())
                        .toList() ??
                    [],
                foodName: meal['food_Name_Arabic'] ?? 'Unknown',
                foodImage:
                    meal['food_Image'] ?? 'https://via.placeholder.com/150',
                calories: meal['calories'] ?? 0,
                weight: meal['weight'] ?? 0,
                fat: meal['fat'] ?? 0,
                carbs: meal['carbs'] ?? 0,
                protein: meal['protein'] ?? 0,
                isCompleted: isCompleted,
                animationController: _controller,
                // isMinimized: isMinimized,
                // onToggleMinimize: toggleMinimize,
                meal_id: meal['id'] ?? 12,
              );
            }).toList(),
          );
        }
      },
    );
  }
}
