import 'package:flutter/material.dart';

class NutritionDetails extends StatefulWidget {
  @override
  _NutritionDetailsState createState() => _NutritionDetailsState();
}

class _NutritionDetailsState extends State<NutritionDetails>
    with SingleTickerProviderStateMixin {
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
    "Create Your Own": {}, // Placeholder for custom diet
  };

  // Custom macronutrient values for "Create Your Own"
  double customProtein = 100;
  double customCarbs = 200;
  double customFat = 50;

  late AnimationController _animationController;

  // Method to calculate total calories based on custom values
  double calculateCalories() {
    return (customProtein * 4 + customCarbs * 4 + customFat * 9);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = nutritionData[selectedDiet] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs for diet selection with scrollable view
        Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  "Balanced",
                  "Low Fat",
                  "Low Carb",
                  "High Protein",
                  "Create Your Own"
                ]
                    .map((diet) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDiet = diet;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
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
            ),
            // Glowing indicator to show more tabs on the right
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: FadeTransition(
                opacity: _animationController,
                child: Container(
                  width: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Nutrition Details or Custom Controls
        selectedDiet == "Create Your Own"
            ? _buildCustomDietControls()
            : _buildNutritionDetails(currentData),
      ],
    );
  }

  Widget _buildNutritionDetails(Map<String, String> data) {
    return Card(
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
              value: data["Protein"] ?? "N/A",
              icon: Icons.local_fire_department_rounded,
              color: Colors.blue,
            ),
            const Divider(height: 20, color: Colors.grey),
            NutritionRow(
              label: "Carbs",
              value: data["Carbs"] ?? "N/A",
              icon: Icons.energy_savings_leaf_rounded,
              color: Colors.green,
            ),
            const Divider(height: 20, color: Colors.grey),
            NutritionRow(
              label: "Fat",
              value: data["Fat"] ?? "N/A",
              icon: Icons.oil_barrel_rounded,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDietControls() {
    final totalCalories = calculateCalories();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Total Calories: $totalCalories kcal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: totalCalories > 2000 ? Colors.red : Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: "Protein",
              value: customProtein,
              color: Colors.blue,
              onChanged: (value) => setState(() {
                customProtein = value;
              }),
            ),
            _buildSlider(
              label: "Carbs",
              value: customCarbs,
              color: Colors.green,
              onChanged: (value) => setState(() {
                customCarbs = value;
              }),
            ),
            _buildSlider(
              label: "Fat",
              value: customFat,
              color: Colors.orange,
              onChanged: (value) => setState(() {
                customFat = value;
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toInt()} grams",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Slider(
          value: value,
          min: 0,
          max: label == "Fat" ? 100 : 300,
          divisions: 100,
          activeColor: color,
          label: "${value.toInt()} g",
          onChanged: onChanged,
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
                color: Colors.black,
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
