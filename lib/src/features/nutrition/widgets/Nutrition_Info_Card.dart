import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Nutrition_Info_Card extends StatelessWidget {
  const Nutrition_Info_Card({
    super.key,
    required this.foodName,
    required this.foodImage,
    required this.calories,
    required this.weight,
    required this.fat,
    required this.carbs,
    required this.protein,
  });

  final String foodName;
  final String foodImage;
  final int calories;
  final int weight;
  final int fat;
  final int carbs;
  final int protein;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                foodImage,
                width: screenWidth * 0.25,
                height: screenWidth * 0.40,
                fit: BoxFit.fill,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('$weight gr', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.red),
                      const SizedBox(width: 4),
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
                        FontAwesomeIcons.pizzaSlice,
                        '$fat gr',
                        'Fat',
                      ),
                      _buildNutrientInfo(
                        FontAwesomeIcons.breadSlice,
                        '$carbs gr',
                        'Carbs',
                      ),
                      _buildNutrientInfo(
                        FontAwesomeIcons.fish,
                        '$protein gr',
                        'Protein',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(IconData icon, String amount, String label) {
    return Column(children: [
      FaIcon(
        icon,
        size: 22,
        color: Colors.green,
      ),
      const SizedBox(height: 8),
      Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      )
    ]);
  }
}
