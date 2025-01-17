import 'package:shared_preferences/shared_preferences.dart';

class MealPlanService {
  final List<Map<String, dynamic>> mealPlans = [
    {
      "breakfast": {
        "mincal": 0.15,
        "medin": 0.20,
        "maxcal": 0.25,
        "description": "Day 0 Breakfast"
      },
      "lunch": {
        "mincal": 0.45,
        "medin": 0.475,
        "maxcal": 0.50,
        "description": "Day 0 Lunch"
      },
      "dinner": {
        "mincal": 0.30,
        "medin": 0.325,
        "maxcal": 0.35,
        "description": "Day 0 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.35,
        "medin": 0.40,
        "maxcal": 0.45,
        "description": "Day 1 Breakfast"
      },
      "lunch": {
        "mincal": 0.25,
        "medin": 0.275,
        "maxcal": 0.30,
        "description": "Day 1 Lunch"
      },
      "dinner": {
        "mincal": 0.30,
        "medin": 0.325,
        "maxcal": 0.35,
        "description": "Day 1 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.20,
        "medin": 0.25,
        "maxcal": 0.30,
        "description": "Day 2 Breakfast"
      },
      "lunch": {
        "mincal": 0.40,
        "medin": 0.425,
        "maxcal": 0.45,
        "description": "Day 2 Lunch"
      },
      "dinner": {
        "mincal": 0.30,
        "medin": 0.325,
        "maxcal": 0.35,
        "description": "Day 2 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.25,
        "medin": 0.30,
        "maxcal": 0.35,
        "description": "Day 3 Breakfast"
      },
      "lunch": {
        "mincal": 0.30,
        "medin": 0.35,
        "maxcal": 0.40,
        "description": "Day 3 Lunch"
      },
      "dinner": {
        "mincal": 0.35,
        "medin": 0.40,
        "maxcal": 0.45,
        "description": "Day 3 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.40,
        "medin": 0.42,
        "maxcal": 0.45,
        "description": "Day 4 Breakfast"
      },
      "lunch": {
        "mincal": 0.20,
        "medin": 0.25,
        "maxcal": 0.30,
        "description": "Day 4 Lunch"
      },
      "dinner": {
        "mincal": 0.30,
        "medin": 0.325,
        "maxcal": 0.35,
        "description": "Day 4 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.15,
        "medin": 0.20,
        "maxcal": 0.25,
        "description": "Day 5 Breakfast"
      },
      "lunch": {
        "mincal": 0.45,
        "medin": 0.475,
        "maxcal": 0.50,
        "description": "Day 5 Lunch"
      },
      "dinner": {
        "mincal": 0.30,
        "medin": 0.325,
        "maxcal": 0.35,
        "description": "Day 5 Dinner"
      }
    },
    {
      "breakfast": {
        "mincal": 0.30,
        "medin": 0.35,
        "maxcal": 0.40,
        "description": "Day 6 Breakfast"
      },
      "lunch": {
        "mincal": 0.35,
        "medin": 0.375,
        "maxcal": 0.40,
        "description": "Day 6 Lunch"
      },
      "dinner": {
        "mincal": 0.25,
        "medin": 0.275,
        "maxcal": 0.30,
        "description": "Day 6 Dinner"
      }
    }
  ];

  Map<String, dynamic>? _findMealInRange(
    List<Map<String, dynamic>> meals,
    double calorieValue,
    double totalCalories,
  ) {
    Map<String, dynamic>? bestMatch;
    double closestDifference = double.infinity;

    for (var meal in meals) {
      double minCal = meal['mincal'] * totalCalories;
      double maxCal = meal['maxcal'] * totalCalories;
      double targetCal = calorieValue * totalCalories;

      // Calculate how far this meal is from our target
      double diff;
      if (targetCal < minCal) {
        diff = minCal - targetCal;
      } else if (targetCal > maxCal) {
        diff = targetCal - maxCal;
      } else {
        // Within range - perfect match!
        return meal;
      }

      if (diff < closestDifference) {
        closestDifference = diff;
        bestMatch = meal;
      }
    }

    return bestMatch;
  }

  Future<Map<String, dynamic>> findClosestMealPlan(
      String mealType, double calorieValue, double totalCalories) async {
    // Flatten all meals for comparison
    List<Map<String, dynamic>> allMeals = mealPlans
        .expand((dayPlan) => dayPlan.entries
            .where((entry) => entry.key == mealType)
            .map((entry) => entry.value as Map<String, dynamic>))
        .toList();

    // First try exact range
    Map<String, dynamic>? closestMeal = _findMealInRange(
      allMeals,
      calorieValue,
      totalCalories,
    );

    // If no meal found in exact range, start alternating search
    if (closestMeal == null || closestMeal.isEmpty) {
      int offset = 1;
      final maxOffset = (totalCalories * 0.5)
          .round(); // Limit search to 50% of total calories

      while (offset < maxOffset) {
        // Try below the range
        double lowerValue = calorieValue - (offset / totalCalories);
        closestMeal = _findMealInRange(
          allMeals,
          lowerValue,
          totalCalories,
        );

        // If found, break the loop
        if (closestMeal != null && closestMeal.isNotEmpty) {
          print("Found meal below range at offset $offset");
          break;
        }

        // Try above the range
        double upperValue = calorieValue + (offset / totalCalories);
        closestMeal = _findMealInRange(
          allMeals,
          upperValue,
          totalCalories,
        );

        // If found, break the loop
        if (closestMeal != null && closestMeal.isNotEmpty) {
          print("Found meal above range at offset $offset");
          break;
        }

        offset++;
      }
    }

    // Log the result for debugging
    if (closestMeal != null && closestMeal.isNotEmpty) {
      double minCalValue = closestMeal['mincal'] * totalCalories;
      double maxCalValue = closestMeal['maxcal'] * totalCalories;
      double actualCalValue = calorieValue * totalCalories;

      print(
          "For $mealType, you asked for calories between ${closestMeal['mincal']} (${minCalValue.toStringAsFixed(1)} cal) "
          "and ${closestMeal['maxcal']} (${maxCalValue.toStringAsFixed(1)} cal), "
          "and I found ${calorieValue.toStringAsFixed(2)} (${actualCalValue.toStringAsFixed(1)} cal).");
    } else {
      print("No suitable meal found for $mealType.");
    }

    return closestMeal ?? {};
  }

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
