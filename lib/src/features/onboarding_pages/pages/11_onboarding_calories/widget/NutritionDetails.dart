import 'package:flutter/material.dart';

class NutritionDetails extends StatefulWidget {
  @override
  _NutritionDetailsState createState() => _NutritionDetailsState();
}

class _NutritionDetailsState extends State<NutritionDetails> {
  String selectedDiet = "Balanced"; // Default selected diet

  // Nutrition data for each diet type
  final Map<String, Map<String, String>> nutritionData = {
    "Balanced": {
      "Protein": "126 grams/day",
      "Carbs": "276 grams/day",
      "Fat": "59 grams/day",
    },
    "Low Fat": {
      "Protein": "130 grams/day",
      "Carbs": "300 grams/day",
      "Fat": "50 grams/day",
    },
    "Low Carb": {
      "Protein": "150 grams/day",
      "Carbs": "120 grams/day",
      "Fat": "80 grams/day",
    },
    "High Protein": {
      "Protein": "200 grams/day",
      "Carbs": "180 grams/day",
      "Fat": "70 grams/day",
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentData = nutritionData[selectedDiet] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs for diet selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ["Balanced", "Low Fat", "Low Carb", "High Protein"]
              .map((diet) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDiet = diet;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: selectedDiet == diet
                            ? Colors.teal.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedDiet == diet
                              ? Colors.teal
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        diet,
                        style: TextStyle(
                          color: selectedDiet == diet
                              ? Colors.teal
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        // Nutrition Details Table
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                NutritionRow(
                  label: "Protein",
                  value: currentData["Protein"] ?? "N/A",
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.blue,
                ),
                const Divider(height: 20, color: Colors.grey),
                NutritionRow(
                  label: "Carbs",
                  value: currentData["Carbs"] ?? "N/A",
                  icon: Icons.energy_savings_leaf_rounded,
                  color: Colors.green,
                ),
                const Divider(height: 20, color: Colors.grey),
                NutritionRow(
                  label: "Fat",
                  value: currentData["Fat"] ?? "N/A",
                  icon: Icons.oil_barrel_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const NutritionRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}
