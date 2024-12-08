import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/widgets/MealDetailCard.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService_launch.dart';

class MealRow extends StatelessWidget {
  final DateTime date;
  final bool isExpanded;
  final VoidCallback onTapExpand;

  MealRow({
    super.key,
    required this.date,
    this.isExpanded = false,
    required this.onTapExpand,
  });
  final FoodService_breakfast foodService = FoodService_breakfast();
  // List<Map<String, dynamic>> foods = await foodService.getFoods();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isExpanded ? 250 : 100,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: MealDetailCard(
                mealType: 'Breakfast',
                selectedDay: date,
                fetchFoodData: () =>
                    foodService.getFoods(100, 132), // this not depent
                isExpanded: isExpanded,
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 0.2),
            Expanded(
              child: MealDetailCard(
                mealType: 'Lunch',
                selectedDay: date,
                fetchFoodData: FoodService_launch().getFoods,
                isExpanded: isExpanded,
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 0.2),
            Expanded(
              child: MealDetailCard(
                mealType: 'Dinner',
                selectedDay: date,
                fetchFoodData: FoodService_Dinner().getFoods,
                isExpanded: isExpanded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
