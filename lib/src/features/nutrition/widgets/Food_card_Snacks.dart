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
  _DinnerState createState() => _DinnerState();
}

class _DinnerState extends State<snacks> {
  final FoodService_snacks foodService = FoodService_snacks();
  late Future<Map<String, dynamic>?> closestsnacksMeal;

  @override
  void initState() {
    super.initState();
    closestsnacksMeal = _loadClosestMeal();
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
    return FutureBuilder<Map<String, dynamic>?>(
      future: closestsnacksMeal,
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
          final steps = (meal['preparation_steps'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              <String>[];
          final tips = (meal['tips'] as List<dynamic>?)
                  ?.map((item) => item as Map<String, dynamic>)
                  .toList() ??
              <Map<String, dynamic>>[];
          return NutritionInfoCard(
            tips: tips,
            steps: steps,
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
