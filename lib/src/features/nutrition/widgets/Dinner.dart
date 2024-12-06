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

class _DinnerState extends State<Dinner> with SingleTickerProviderStateMixin {
  final FoodService_Dinner foodService = FoodService_Dinner();
  late Future<Map<String, dynamic>?> closestDinnerMeal;
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
    closestDinnerMeal = _loadClosestMeal();
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
      isMinimized = true; // Set to true when completed
    });
    _controller.forward(); // Starts the checkmark animation
  }

  Future<Map<String, dynamic>?> _loadClosestMeal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Get user macros and adjust for dinner (25-35% of daily calories)
    double proteinGrams = prefs.getDouble('proteinGrams') ?? 200.toDouble();
    double carbsGrams = prefs.getDouble('carbsGrams') ?? 200.toDouble();
    double fatsGrams = prefs.getDouble('fatsGrams') ?? 0.toDouble();
    double calories = prefs.getDouble('calories') ?? 2000.toDouble();

    // Fetch food data from the service
    List<Map<String, dynamic>> foods = await foodService.getFoods();

    // Fetch the closest meal for dinner
    return await MealService().getClosestMeal(
        calories, proteinGrams, carbsGrams, fatsGrams, foods, 'Dinner');
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
            calories: (meal['calories'] ?? 0).toDouble(),
            weight: (meal['weight'] ?? 0).toDouble(),
            fat: (meal['fat'] ?? 0).toDouble(),
            carbs: (meal['carbs'] ?? 0).toDouble(),
            protein: (meal['protein'] ?? 0).toDouble(),
            isCompleted: isCompleted,
            animationController: _controller,
            // isMinimized: isMinimized,
            meal_id: meal['id'] ?? 15,
            // onToggleMinimize: toggleMinimize,
          );
        }
      },
    );
  }
}
