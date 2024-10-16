import 'package:flutter/widgets.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';

class Breakfast extends StatelessWidget {
  final FoodService foodService = FoodService();

  Breakfast({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: foodService.getFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: AppLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No food items available'));
        } else {
          List<Map<String, dynamic>> eggFoods = snapshot.data!.where((food) {
            // return food['Tags']?.contains('Foul') ?? true;
          }).toList();

          if (eggFoods.isEmpty) {
            return const Center(
                child: Text('No "Foul" tagged food items found'));
          }

          var food = eggFoods[0];

          return Nutrition_Info_Card(
            foodName: food['food_Name'] ?? 'Unknown',
            foodImage: food['food_Image'] ?? 'https://via.placeholder.com/150',
            calories: food['calories'] ?? 0,
            weight: food['weight'] ?? 0,
            fat: food['fat'] ?? 0,
            carbs: food['carbs'] ?? 0,
            protein: food['protein'] ?? 0,
          );
        }
      },
    );
  }
}
