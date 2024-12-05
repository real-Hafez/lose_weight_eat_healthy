import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Progress_Indicator.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Macro_Detail.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Nutrition_Detail.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
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

  String _formatMacronutrientGrams(int grams) {
    if (grams <= 0) return "0${S().g}";
    return "${grams.toStringAsFixed(0)}${S().g}";
  }

  String _convertBasedOnLanguage(String input) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? NumberConversionHelper.convertToArabicNumbers(input)
        : input;
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
          AutoSizeText(
            "${S().NutritionBudget}",
            maxLines: 1,
            minFontSize: 14,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.sizeOf(context).height * .03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * .02),
          Calorie_Progress_Indicator(),
          SizedBox(height: MediaQuery.sizeOf(context).height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutritionDetail(
                label: "${S().Calories}",
                value: _convertBasedOnLanguage(calories.round().toString()),
              ),
              NutritionDetail(
                label: "${S().burned}",
                value: _convertBasedOnLanguage("221"),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Macro_Detail(
                icon: Icons.local_pizza,
                label:
                    '${_convertBasedOnLanguage(_formatMacronutrientGrams(fatsGrams))} ${S().fats}',
              ),
              Macro_Detail(
                icon: Icons.rice_bowl,
                label:
                    '${_convertBasedOnLanguage(_formatMacronutrientGrams(carbsGrams))} ${S().Carbs}',
              ),
              Macro_Detail(
                icon: Icons.fitness_center,
                label:
                    '${_convertBasedOnLanguage(_formatMacronutrientGrams(proteinGrams))} ${S().Protein}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
