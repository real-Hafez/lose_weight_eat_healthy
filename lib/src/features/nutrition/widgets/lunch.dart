import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/mealPlans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lunch extends StatefulWidget {
  const Lunch({
    super.key,
    required this.mincal,
    required this.maxcal,
    required this.remainingCalories,
    required this.description,
  });

  final double mincal;
  final double maxcal;
  final double remainingCalories;
  final String description;

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FoodService_launch _foodService = FoodService_launch();
  final MealService _mealService = MealService();
  final MealPlanService _mealPlanService = MealPlanService();
  bool _isLoading = true;
  Map<String, dynamic>? _closestMeal;
  double _totalCalories = 0;
  double _consumedCalories = 0;
  String _description = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _description = widget.description;
    _loadClosestMeal();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadClosestMeal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch total daily calories from preferences
      _totalCalories = prefs.getDouble('calories') ?? 2000.0;

      // Calculate calorie range for lunch
      double minCalories = _totalCalories * widget.mincal;
      double maxCalories = _totalCalories * widget.maxcal;

      // Expand search range dynamically if no meals are found
      const double step = 50.0; // Increment step for expanding range
      List<Map<String, dynamic>> foods = [];
      while (foods.isEmpty) {
        // Fetch foods for lunch within current range
        foods = await _foodService.getFoods(minCalories, maxCalories);

        // Filter out completed meals
        foods = await _filterCompletedMeals(foods);

        // If no foods are found, incrementally expand the range
        if (foods.isEmpty) {
          minCalories = (minCalories - step).clamp(0, double.infinity);
          maxCalories += step;
          if (minCalories < 0 && maxCalories > _totalCalories)
            break; // Break to avoid infinite loop
        }
      }

      // Get the closest meal if meals are found
      final closestMeal = foods.isNotEmpty
          ? await _mealService.getClosestMeal(
              _totalCalories,
              prefs.getDouble('proteinGrams') ?? 200,
              prefs.getDouble('carbsGrams') ?? 200,
              prefs.getDouble('fatsGrams') ?? 0,
              foods,
              'lunch',
            )
          : null;

      // Extract the consumed calories
      _consumedCalories = (closestMeal?['calories'] as num?)?.toDouble() ?? 0;

      // Calculate remaining calories dynamically
      final double remainingCalories = _totalCalories - _consumedCalories;

      setState(() {
        _closestMeal = closestMeal;
        _isLoading = false;

        // Update the description dynamically
        _description = closestMeal != null
            ? 'You have consumed $_consumedCalories calories '
                'for lunch. Remaining calories for the day: $remainingCalories cal.'
            : 'No suitable meal found for the given criteria.';
      });
    } catch (e) {
      print('Error loading closest meal: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _filterCompletedMeals(
      List<Map<String, dynamic>> foods) async {
    List<Map<String, dynamic>> filteredFoods = [];
    for (var food in foods) {
      bool isCompleted = await _mealPlanService.isMealCompleted(food['id']);
      if (!isCompleted) {
        filteredFoods.add(food);
      }
    }
    return filteredFoods;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_closestMeal == null) {
      return const Center(child: Text('No suitable lunch found'));
    } else {
      // Local calculation of remaining calories
      final double remainingCalories =
          widget.remainingCalories - _consumedCalories;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              print('Meal tapped: ${_closestMeal!['id']}');
              _mealPlanService.markMealAsCompleted(_closestMeal!['id']);
              _mealPlanService.clearOldCompletedMeals();
            },
            child: NutritionInfoCard(
              foodName: Localizations.localeOf(context).languageCode == 'ar'
                  ? _closestMeal!['food_Name_Arabic'] ?? 'Unknown'
                  : _closestMeal!['food_Name'] ?? 'Unknown',
              foodImage: _closestMeal!['food_Image'] ??
                  'https://via.placeholder.com/150',
              calories: _consumedCalories,
              weight: (_closestMeal!['weight'] as num?)?.toDouble() ?? 0.0,
              fat: (_closestMeal!['fat'] as num?)?.toDouble() ?? 0.0,
              carbs: (_closestMeal!['carbs'] as num?)?.toDouble() ?? 0.0,
              protein: (_closestMeal!['protein'] as num?)?.toDouble() ?? 0.0,
              isCompleted: false,
              Ingredients:
                  (_closestMeal!['ingredients_Ar'] as List<dynamic>? ?? [])
                      .map((item) => item.toString())
                      .toList(),
              steps:
                  (_closestMeal!['preparation_steps'] as List<dynamic>? ?? [])
                      .map((item) => item.toString())
                      .toList(),
              tips: (_closestMeal!['tips'] as List<dynamic>? ?? [])
                  .map((item) => item as Map<String, dynamic>)
                  .toList(),
              animationController: _controller,
              meal_id: _closestMeal!['id'],
            ),
          ),
          // Text(
          //   _closestMeal!['id'].toString(),
          //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          // ),
        ],
      );
    }
  }
}
