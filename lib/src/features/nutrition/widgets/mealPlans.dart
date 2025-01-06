import 'package:shared_preferences/shared_preferences.dart';

class MealPlanService {
  final List<Map<String, dynamic>> mealPlans = [
    // Day 0
    {
      "breakfast": {
        "mincal": 0.00,
        "maxcal": 0.10,
        "description": "Day 0 Breakfast"
      },
      "lunch": {"mincal": 0.00, "maxcal": 0.20, "description": "Day 0 Lunch"},
      "dinner": {"mincal": 0.00, "maxcal": 0.10, "description": "Day 0 Dinner"}
    },
    // Day 1
    {
      "breakfast": {
        "mincal": 0.20,
        "maxcal": 0.60,
        "description": "Day 1 Breakfast"
      },
      "lunch": {"mincal": 0.30, "maxcal": 0.50, "description": "Day 1 Lunch"},
      "dinner": {"mincal": 0.20, "maxcal": 0.60, "description": "Day 1 Dinner"}
    },
    // Day 2
    {
      "breakfast": {
        "mincal": 0.00,
        "maxcal": 0.60,
        "description": "Day 2 Breakfast"
      },
      "lunch": {"mincal": 0.45, "maxcal": 0.55, "description": "Day 2 Lunch"},
      "dinner": {"mincal": 0.25, "maxcal": 0.30, "description": "Day 2 Dinner"}
    },
    // Day 3
    {
      "breakfast": {
        "mincal": 0.30,
        "maxcal": 0.50,
        "description": "Day 3 Breakfast"
      },
      "lunch": {"mincal": 0.00, "maxcal": 0.35, "description": "Day 3 Lunch"},
      "dinner": {"mincal": 0.0, "maxcal": 0.20, "description": "Day 3 Dinner"}
    },
    // Day 4
    {
      "breakfast": {
        "mincal": 0.00,
        "maxcal": 0.60,
        "description": "Day 4 Breakfast"
      },
      "lunch": {"mincal": 0.30, "maxcal": 0.40, "description": "Day 4 Lunch"},
      "dinner": {"mincal": 0.30, "maxcal": 0.40, "description": "Day 4 Dinner"}
    },
    // Day 5
    {
      "breakfast": {
        "mincal": 0.00,
        "maxcal": 0.60,
        "description": "Day 5 Breakfast"
      },
      "lunch": {"mincal": 0.40, "maxcal": 0.50, "description": "Day 5 Lunch"},
      "dinner": {"mincal": 0.40, "maxcal": 0.50, "description": "Day 5 Dinner"}
    },
    // Day 6
    {
      "breakfast": {
        "mincal": 0.00,
        "maxcal": 0.60,
        "description": "Day 6 Breakfast"
      },
      "lunch": {"mincal": 0.35, "maxcal": 0.45, "description": "Day 6 Lunch"},
      "dinner": {"mincal": 0.35, "maxcal": 0.45, "description": "Day 6 Dinner"}
    },
  ];

  Future<Map<String, dynamic>> getMealPlanForDay(int day) async {
    return mealPlans[day % mealPlans.length];
  }

  Future<void> markMealAsCompleted(int mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedMeals = prefs.getStringList('completedMeals') ?? [];
    completedMeals.add(mealId.toString());
    await prefs.setStringList('completedMeals', completedMeals);
  }

  Future<bool> isMealCompleted(int mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedMeals = prefs.getStringList('completedMeals') ?? [];
    return completedMeals.contains(mealId.toString());
  }

  Future<void> clearOldCompletedMeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedMeals = prefs.getStringList('completedMeals') ?? [];
    if (completedMeals.length > 8) {
      completedMeals.removeAt(0); // Remove the oldest completed meal
      await prefs.setStringList('completedMeals', completedMeals);
    }
  }

  String getDescription(Map<String, dynamic>? mealPlan, String mealType) {
    return mealPlan?[mealType]?['description'] ?? 'No description available';
  }

  Future<void> incrementDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentDay = prefs.getInt('currentDay') ?? 0;
    await prefs.setInt('currentDay', currentDay + 1);
  }

  Future<int> getCurrentDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentDay') ?? 0;
  }
}
