import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _BreakfastState extends State<Breakfast> {
  final FoodService_breakfast foodService = FoodService_breakfast();
  late Future<Map<String, dynamic>?> closestBreakfastMeal;

  @override
  void initState() {
    super.initState();
    closestBreakfastMeal = _loadClosestMeal();
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get total adjusted calories
    double totalCalories = prefs.getDouble('adjusted_calories_$userId') ?? 0.0;

    // Calculate calorie distribution
    // Map<String, double> mealCalories =
    //     MealService().calculateMealCalories(totalCalories);

    // Use breakfast calories (20-30%)
    // double targetCalories = mealCalories['breakfast'] ?? 0.0;
    double targetProtein = prefs.getDouble('protein_grams_$userId') ?? 0.0;
    double targetCarbs = prefs.getDouble('carbs_grams_$userId') ?? 0.0;
    double targetFats = prefs.getDouble('fats_grams_$userId') ?? 0.0;

    // Fetch food data
    List<Map<String, dynamic>> foods = await foodService.getFoods();

    // Get closest meal
    return await MealService().getClosestMeal(
        targetProtein, targetCarbs, targetFats, targetFats, foods, userId);
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

          // Safely cast ingredients to List<String>
          final ingredients = (meal['ingredients_Ar'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              <String>[];

          return NutritionInfoCard(
            steps: [],
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
