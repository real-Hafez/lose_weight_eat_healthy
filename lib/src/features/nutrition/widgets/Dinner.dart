import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dinner extends StatefulWidget {
  const Dinner({super.key});

  @override
  _DinnerState createState() => _DinnerState();
}

class _DinnerState extends State<Dinner> {
  final FoodService_Dinner foodService = FoodService_Dinner();
  late Future<Map<String, dynamic>?> closestDinnerMeal;

  @override
  void initState() {
    super.initState();
    closestDinnerMeal = _loadClosestMeal();
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

    // Fetch food data from the service
    List<Map<String, dynamic>> foods = await foodService.getFoods();

    // Fetch the closest meal for dinner
    return await MealService().getClosestMeal(adjustedCalories, targetProtein,
        targetCarbs, targetFats, foods, 'Dinner');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: closestDinnerMeal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No suitable dinner found'));
        } else {
          var meal = snapshot.data!;
          // Safely cast ingredients to List<String>
          final ingredients = (meal['ingredients_Ar'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              <String>[];
          return NutritionInfoCard(
            tips: const [],
            steps: const [],
            Ingredients: ingredients,
            foodName: meal['food_Name_Arabic'] ?? 'Unknown',
            foodImage: meal['food_Image'] ?? 'https://via.placeholder.com/150',
            calories: meal['calories'] ?? 0,
            weight: meal['weight'] ?? 0,
            fat: meal['fat'] ?? 0,
            carbs: meal['carbs'] ?? 0,
            protein: meal['protein'] ?? 0,
          );
        }
      },
    );
  }
}
