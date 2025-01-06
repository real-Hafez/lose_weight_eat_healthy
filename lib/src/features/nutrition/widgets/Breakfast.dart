import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/MealService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Breakfast extends StatefulWidget {
  const Breakfast({
    super.key,
    required this.mincal,
    required this.maxcal,
    required this.remainingCalories,
    required this.description,
  });

  final double mincal;
  final double maxcal;
  final double remainingCalories;
  final String description; // Keep as final

  @override
  _BreakfastState createState() => _BreakfastState();
}

class _BreakfastState extends State<Breakfast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FoodService_breakfast _foodService = FoodService_breakfast();
  final MealService _mealService = MealService();
  bool _isLoading = true;
  Map<String, dynamic>? _closestMeal;
  double _totalCalories = 0;
  double _consumedCalories = 0;
  String _description = ''; // State variable to store the updated description

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _description = widget
        .description; // Initialize with the description passed from the parent
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

      // Fetch consumed meals from preferences
      List<String> consumedMeals = prefs.getStringList('consumedMeals') ?? [];
      List<String> recentMeals = _getRecentMeals(consumedMeals);

      // Calculate calorie range for breakfast
      double minCalories = _totalCalories * widget.mincal;
      double maxCalories = _totalCalories * widget.maxcal;

      // Fetch foods excluding recently consumed meals
      List<Map<String, dynamic>> foods = await _foodService.getFoods(
        minCalories,
        maxCalories,
        excludeMeals: recentMeals,
      );

      if (foods.isEmpty) {
        // If no foods found in the exact range, start alternating search
        int offset = 1;
        final maxOffset = (_totalCalories * 0.5)
            .round(); // Limit search to 50% of total calories

        while (foods.isEmpty && offset < maxOffset) {
          // Try below the range
          double lowerMinCalories = minCalories - offset;
          double lowerMaxCalories = maxCalories - offset;
          foods = await _foodService.getFoods(
            lowerMinCalories,
            lowerMaxCalories,
            excludeMeals: recentMeals,
          );

          // If found, break the loop
          if (foods.isNotEmpty) break;

          // Try above the range
          double upperMinCalories = minCalories + offset;
          double upperMaxCalories = maxCalories + offset;
          foods = await _foodService.getFoods(
            upperMinCalories,
            upperMaxCalories,
            excludeMeals: recentMeals,
          );

          offset++;
        }
      }

      if (foods.isNotEmpty) {
        _closestMeal = foods.first;
        _consumedCalories = (_closestMeal?['calories'] as num?)?.toDouble() ??
            0.0; // Correctly fetch calories
        _description =
            _closestMeal?['description'] ?? 'No description available';
      }
      print('Recent Meals: $recentMeals'); // Inside `_loadClosestMeal`
      print('Closest Meal: $_closestMeal');
      print('Calories: $_consumedCalories');

      print('Min Calories: $minCalories, Max Calories: $maxCalories');
      print('Foods fetched: ${foods.length}');
      print('recent meal is $recentMeals');
    } catch (e) {
      print("Error loading meals: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Helper: Get meals consumed in the last 8 days
  List<String> _getRecentMeals(List<String> consumedMeals) {
    DateTime now = DateTime.now();
    return consumedMeals
        .where((entry) {
          final parts = entry.split('|');
          if (parts.length != 2) return false;

          final mealDate = DateTime.tryParse(parts[1]);
          if (mealDate == null) return false;

          return now.difference(mealDate).inDays < 8;
        })
        .map((entry) => entry.split('|').first) // Use meal ID
        .toList();
  }

  void _markMealAsConsumed() async {
    if (_closestMeal == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mark meal as consumed
    String mealEntry = "${_closestMeal?['id']}|${DateTime.now()}";
    List<String> consumedMeals = prefs.getStringList('consumedMeals') ?? [];
    consumedMeals.add(mealEntry);

    await prefs.setStringList('consumedMeals', consumedMeals);

    // Save minimized state
    await prefs.setBool('isMealMinimized', true);

    setState(() {
      _description = 'Meal completed!';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_closestMeal == null) {
      return const Center(child: Text('No suitable breakfast found'));
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
            },
            child: NutritionInfoCard(
              foodName: _closestMeal!['food_Name_Arabic'] ?? 'Unknown',
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
          // const SizedBox(height: 10),
          Text(
            _description, // Use the dynamically updated description from state
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }
}
