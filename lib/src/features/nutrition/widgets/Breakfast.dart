import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isCompleted = false;
  late AnimationController _controller;
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    closestBreakfastMeal = _loadClosestMeal();
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

  Future<void> _saveMealToCache(Map<String, dynamic> meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'cached_breakfast', meal['food_Name_Arabic'] ?? 'Unknown');
    await prefs.setString('cached_breakfast_image', meal['food_Image'] ?? '');
    await prefs.setDouble(
        'cached_breakfast_calories', (meal['calories'] ?? 0).toDouble());
    await prefs.setDouble(
        'cached_breakfast_weight', (meal['weight'] ?? 0).toDouble());
    await prefs.setDouble(
        'cached_breakfast_fat', (meal['fat'] ?? 0).toDouble());
    await prefs.setDouble(
        'cached_breakfast_carbs', (meal['carbs'] ?? 0).toDouble());
    await prefs.setDouble(
        'cached_breakfast_protein', (meal['protein'] ?? 0).toDouble());
  }

  Future<Map<String, dynamic>?> _loadCachedMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? foodName = prefs.getString('cached_breakfast');
    if (foodName == null) return null;

    return {
      'food_Name_Arabic': foodName,
      'food_Image': prefs.getString('cached_breakfast_image') ?? '',
      'calories': prefs.getDouble('cached_breakfast_calories') ?? 0,
      'weight': prefs.getDouble('cached_breakfast_weight') ?? 0,
      'fat': prefs.getDouble('cached_breakfast_fat') ?? 0,
      'carbs': prefs.getDouble('cached_breakfast_carbs') ?? 0,
      'protein': prefs.getDouble('cached_breakfast_protein') ?? 0,
    };
  }

  Future<Map<String, dynamic>?> _fetchFromSupabaseIfNeeded(
      Map<String, dynamic> meal) async {
    // Check if any value is zero
    if ((meal['calories'] ?? 0) == 0 ||
        (meal['weight'] ?? 0) == 0 ||
        (meal['fat'] ?? 0) == 0 ||
        (meal['carbs'] ?? 0) == 0 ||
        (meal['protein'] ?? 0) == 0) {
      // Fetch correct data from Supabase
      Map<String, dynamic>? updatedMeal = await foodService.fetchFromSupabase();

      if (updatedMeal != null) {
        // Update SharedPreferences with the correct values
        await _saveMealToCache(updatedMeal);
        return updatedMeal;
      }
    }
    return meal;
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    // Check if cached meal exists
    Map<String, dynamic>? cachedMeal = await _loadCachedMeal();

    if (cachedMeal != null &&
        (cachedMeal['calories'] ?? 0) > 0 &&
        (cachedMeal['protein'] ?? 0) > 0 &&
        (cachedMeal['carbs'] ?? 0) > 0 &&
        (cachedMeal['fat'] ?? 0) > 0) {
      return cachedMeal;
    }

    // If cached values are zero, re-fetch from Supabase
    List<Map<String, dynamic>> foods = await foodService.getFoods();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double targetProtein = prefs.getDouble('protein_grams_$userId') ?? 0.0;
    double targetCarbs = prefs.getDouble('carbs_grams_$userId') ?? 0.0;
    double targetFats = prefs.getDouble('fats_grams_$userId') ?? 0.0;

    Map<String, dynamic>? closestMeal = await MealService().getClosestMeal(
        targetProtein, targetCarbs, targetFats, targetFats, foods, userId);

    if (closestMeal != null) {
      // Save updated values to cache
      await _saveMealToCache(closestMeal);
    }
    return closestMeal;
  }

  void _markAsCompleted() {
    setState(() {
      isCompleted = true;
    });
    _controller.forward();
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
              foodName: meal['food_Name_Arabic'] ?? 'Unknown',
              foodImage:
                  meal['food_Image'] ?? 'https://via.placeholder.com/150',
              calories: (meal['calories'] ?? 0).toInt(),
              weight: (meal['weight'] ?? 0).toInt(),
              fat: (meal['fat'] ?? 0).toInt(),
              carbs: (meal['carbs'] ?? 0).toInt(),
              protein: (meal['protein'] ?? 0).toInt(),
              isCompleted: isCompleted,
              animationController: _controller,
              Ingredients: ingredients,
              steps: steps,
              tips: tips,
            ),
          );
        }
      },
    );
  }
}
