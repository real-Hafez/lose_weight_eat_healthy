import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

class Nutrition extends StatelessWidget {
  const Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          nutrition_calender(),
          SizedBox(
            height: 25,
          ),
          CalorieTrackerWidget(),
          SizedBox(
            height: 25,
          ),
          Meal_Type_Display(food: "Breakfast"),
          FoodCard(
            foodName: "foul",
            foodImage:
                'assets/body_percentage_fat/body_percentage_fat_man/body_percentage_fat_15%.jpg',
            calories: 100,
            weight: 150,
            fat: 10,
            carbs: 25,
            protein: 35,
          ),
          SizedBox(
            height: 120,
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String foodName;
  final String foodImage;
  final int calories;
  final int weight;
  final int fat;
  final int carbs;
  final int protein;
  // final IconData fatIcon;
  // final IconData carbsIcon;
  // final IconData proteinIcon;

  const FoodCard({
    super.key,
    required this.foodName,
    required this.foodImage,
    required this.calories,
    required this.weight,
    required this.fat,
    required this.carbs,
    required this.protein,
    // this.fatIcon = FontAwesomeIcons.pizzaSlice,
    // this.carbsIcon = FontAwesomeIcons.breadSlice,
    // this.proteinIcon = FontAwesomeIcons.fish,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                foodImage,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '$weight gr',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Calories
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.red),
                    Text(
                      '$calories cal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNutrientInfo(
                        FontAwesomeIcons.pizzaSlice, '$fat gr', 'Fat'),
                    _buildNutrientInfo(
                        FontAwesomeIcons.carBurst, '$carbs gr', 'Carbs'),
                    _buildNutrientInfo(
                        FontAwesomeIcons.fish, '$protein gr', 'Protein'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(
    IconData icon,
    String amount,
    String label,
  ) {
    return Column(
      children: [
        FaIcon(icon, size: 22),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
