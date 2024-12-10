import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lunch extends StatefulWidget {
  const Lunch({super.key});

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> with SingleTickerProviderStateMixin {
  final FoodService_launch foodService = FoodService_launch();
  late Future<Map<String, dynamic>?> closestLunchMeal;
  bool isCompleted = false;
  late AnimationController _controller;
  bool isMinimized = false;

  void toggleMinimize() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  @override
  void initState() {
    super.initState();
    closestLunchMeal = _loadClosestMeal();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
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
      isMinimized = true;
    });
    _controller.forward();
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve user preferences for macros
    double proteinGrams = prefs.getDouble('proteinGrams')?.toDouble() ?? 200.0;
    double carbsGrams = prefs.getDouble('carbsGrams')?.toDouble() ?? 200.0;
    double fatsGrams = prefs.getDouble('fatsGrams')?.toDouble() ?? 0.0;
    double calories = prefs.getDouble('calories')?.toDouble() ?? 2000.0;

    // Fetch foods from the service
    List<Map<String, dynamic>> foods = await foodService.getFoods();
//here i want to pritn that
//    print('Calories: $foodCalories (${calPercentage.toStringAsFixed(2)}%)');
    // print('Protein: $foodProtein (${proteinPercentage.toStringAsFixed(2)}%)');
    // print('Carbs: $foodCarbs (${carbsPercentage.toStringAsFixed(2)}%)');
    // print('fats: $foodfat (${fatPercentage.toStringAsFixed(2)}%)'); that coming from breajfast

    // Get closest lunch meal
    return await MealService().getClosestMeal(
      calories,
      proteinGrams,
      carbsGrams,
      fatsGrams,
      foods,
      'Lunch',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: closestLunchMeal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No suitable lunch found'));
        } else {
          var meal = snapshot.data!;

          // Safely cast data fields
          final ingredients = (meal['ingredients_Ar'] as List<dynamic>? ?? [])
              .map((item) => item.toString())
              .toList();
          final steps = (meal['preparation_steps'] as List<dynamic>? ?? [])
              .map((item) => item.toString())
              .toList();
          final tips = (meal['tips'] as List<dynamic>? ?? [])
              .map((item) => item as Map<String, dynamic>)
              .toList();

          return NutritionInfoCard(
            tips: tips,
            steps: steps,
            Ingredients: ingredients,
            foodName: meal['food_Name_Arabic'] ?? 'Unknown',
            foodImage: meal['food_Image'] ?? 'https://via.placeholder.com/150',
            calories: (meal['calories'] ?? 0).toDouble(),
            weight: (meal['weight'] ?? 0).toDouble(),
            fat: (meal['fat'] ?? 0).toDouble(),
            carbs: (meal['carbs'] ?? 0).toDouble(),
            protein: (meal['protein'] ?? 0).toDouble(),
            isCompleted: isCompleted,
            animationController: _controller,
            meal_id: meal['id'] ?? 0,
          );
        }
      },
    );
  }
}
