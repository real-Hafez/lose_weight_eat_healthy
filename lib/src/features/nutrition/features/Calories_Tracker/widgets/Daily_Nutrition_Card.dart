import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Progress_Indicator.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Macro_Detail.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Nutrition_Detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Daily_Nutrition_Card extends StatefulWidget {
  const Daily_Nutrition_Card({super.key});

  @override
  _DailyNutritionCardState createState() => _DailyNutritionCardState();
}

class _DailyNutritionCardState extends State<Daily_Nutrition_Card> {
  int proteinGrams = 0;
  int carbsGrams = 0;
  int fatsGrams = 0;
  int calories = 0;

  @override
  void initState() {
    super.initState();
    _loadMacronutrients();
  }

  Future<void> _loadMacronutrients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    setState(() {
      proteinGrams = prefs.getInt('proteinGrams') ?? 200;
      carbsGrams = prefs.getInt('carbsGrams') ?? 200;
      fatsGrams = prefs.getInt('fatsGrams') ?? 0;
      calories = prefs.getInt('calories') ?? 2000;
    });

    print("Fetched Macronutrients:");
    print("Protein: $proteinGrams grams");
    print("Carbs: $carbsGrams grams");
    print("Fats: $fatsGrams grams");
    print("Calories: $calories kcal");
  }

  String _formatMacronutrient(double grams, String type) {
    if (grams <= 0) return "0 $type";
    int totalGrams = proteinGrams + carbsGrams + fatsGrams;
    double percentage = (grams / totalGrams) * 100;
    return "${percentage.toStringAsFixed(1)}% $type";
  }

  String _formatMacronutrientGrams(double grams) {
    if (grams <= 0) return "0g";
    return "${grams.toStringAsFixed(0)}g";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF5958D0),
        borderRadius: BorderRadius.circular(25.0),
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
          const Calorie_Progress_Indicator(age: 22),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutritionDetail(
                  label: "Calories", value: "${calories.round()} kcal"),
              NutritionDetail(label: "Burned", value: "221 kcal"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Macro_Detail(
              //   icon: Icons.local_pizza,
              //   label: '${_formatMacronutrientGrams(fatsGrams)} Fats',
              // ),
              // Macro_Detail(
              //   icon: Icons.rice_bowl,
              //   label: '${_formatMacronutrientGrams(carbsGrams)} Carbs',
              // ),
              // Macro_Detail(
              //   icon: Icons.fitness_center,
              //   label: '${_formatMacronutrientGrams(proteinGrams)} Protein',
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
