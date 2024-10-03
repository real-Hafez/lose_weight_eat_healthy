import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

class Nutrition extends StatelessWidget {
  final FoodService foodService = FoodService();

  Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: foodService.getFoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No food items available'));
          } else {
            List<Map<String, dynamic>> eggFoods = snapshot.data!.where((food) {
              return food['Tags']?.contains('Foul') ?? false;
            }).toList();

            return Column(
              children: [
                const SizedBox(height: 25),
                const nutrition_calender(),
                const SizedBox(height: 25),
                const CalorieTrackerWidget(),
                const SizedBox(height: 25),
                const Meal_Type_Display(food: "Breakfast"),
                ...eggFoods.map((food) {
                  return Food_Card(
                    foodName: food['food_Name'] ?? 'Unknown',
                    foodImage:
                        food['food_Image'] ?? 'https://via.placeholder.com/150',
                    calories: food['calories'] ?? 0,
                    weight: food['weight'] ?? 0,
                    fat: food['fat'] ?? 0,
                    carbs: food['carbs'] ?? 0,
                    protein: food['protein'] ?? 0,
                  );
                }),
                const SizedBox(height: 120),
              ],
            );
          }
        },
      ),
    );
  }
}
