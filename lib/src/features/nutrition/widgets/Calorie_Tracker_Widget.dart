import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NutritionBudgetWidget extends StatelessWidget {
  const NutritionBudgetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NutritionCard();
  }
}

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF5958D0), 
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Nutrition Budget",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 13.0,
            percent: 1339 / 1800, 
            center: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 30),
                SizedBox(height: 5),
                Text(
                  "1335 Kcal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/1800 Kcal",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            progressColor: Colors.orange,
            backgroundColor: Colors.white12,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutritionDetail(label: "Consumed", value: "1556 kcal"),
              NutritionDetail(label: "Burned", value: "221 kcal"),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MacroDetail(icon: Icons.local_pizza, label: "17% Fat"),
              MacroDetail(icon: Icons.rice_bowl, label: "54% Carbs"),
              MacroDetail(icon: Icons.fitness_center, label: "29% Protein"),
            ],
          ),
        ],
      ),
    );
  }
}

class NutritionDetail extends StatelessWidget {
  final String label;
  final String value;

  const NutritionDetail({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

class MacroDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const MacroDetail({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
