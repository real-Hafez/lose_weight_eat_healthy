import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/widget/NutritionDetails.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatefulWidget {
  const CaloriesChart({
    Key? key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  }) : super(key: key);

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<CaloriesChart> createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<String> _getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_goal') ?? 'No goal set';
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final gender = prefs.getString('gender') ?? 'Not set';
    final weight = prefs.getDouble('weightKg') ?? 0.0;
    final height = prefs.getDouble('heightCm') ?? 0.0;
    final age = prefs.getInt('age') ?? 0;

    double activityLevelCalc = 1.0;
    if (prefs.containsKey('selectedCalculation')) {
      final dynamic storedValue = prefs.get('selectedCalculation');
      if (storedValue is double) {
        activityLevelCalc = storedValue;
      } else if (storedValue is String) {
        activityLevelCalc = double.tryParse(storedValue) ?? 1.0;
      }
    }

    return {
      'gender': gender,
      'weight': weight,
      'height': height,
      'age': age,
      'selectedCalculation': activityLevelCalc,
    };
  }

  Map<String, double> _calculateMacros(double finalCalories) {
    const proteinRatio = 0.2;
    const carbRatio = 0.5;
    const fatRatio = 0.3;

    final proteinCalories = finalCalories * proteinRatio;
    final carbCalories = finalCalories * carbRatio;
    final fatCalories = finalCalories * fatRatio;

    final proteinGrams = proteinCalories / 4;
    final carbGrams = carbCalories / 4;
    final fatGrams = fatCalories / 9;

    return {
      'Protein': proteinGrams,
      'Carbs': carbGrams,
      'Fat': fatGrams,
    };
  }

  double _calculateCalories(
      String gender, double weight, double height, int age) {
    gender = gender.toLowerCase();
    if (gender == 'man' || gender == 'male' || gender == 'ذكر') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (gender == 'woman' || gender == 'female' || gender == 'أنثى') {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      return 0.0;
    }
  }

  double _calculateFinalCalories(double baseCalories, String goal) {
    double adjustment = 0.0;

    switch (goal) {
      case 'Lose 1.0':
        adjustment = -1000;
        break;
      case 'Lose 0.5':
        adjustment = -500;
        break;
      case 'Lose 0.7':
        adjustment = -700;
        break;
      case 'Gain 0.5':
        adjustment = 500;
        break;
      case 'Gain 1.0':
        adjustment = 1000;
        break;
      case 'Gain 0.7':
        adjustment = 700;
        break;
      default:
        adjustment = 0.0;
    }

    return baseCalories + adjustment;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          final gender = data['gender'];
          final weight = data['weight'];
          final height = data['height'];
          final age = data['age'];
          final activityLevelCalc = data['selectedCalculation'];

          final calories = _calculateCalories(gender, weight, height, age);
          final adjustedCalories = calories * activityLevelCalc;

          return FutureBuilder<String>(
            future: _getGoal(),
            builder: (context, goalSnapshot) {
              final goal = goalSnapshot.data ?? 'No goal set';
              final finalCalories =
                  _calculateFinalCalories(adjustedCalories, goal);
              final macros = _calculateMacros(finalCalories);

              final protein = macros['Protein']!;
              final carbs = macros['Carbs']!;
              final fats = macros['Fat']!;

              final totalMacros = protein + carbs + fats;
              final proteinPercentage = (protein / totalMacros) * 100;
              final carbsPercentage = (carbs / totalMacros) * 100;
              final fatsPercentage = (fats / totalMacros) * 100;

              final List<ChartData> chartData = [
                ChartData('Protein', proteinPercentage, Colors.blue, protein),
                ChartData('Carbs', carbsPercentage, Colors.green, carbs),
                ChartData('Fat', fatsPercentage, Colors.orange, fats),
              ];

              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gender: $gender\n'
                      'Weight: ${weight.toStringAsFixed(1)} kg\n'
                      'Height: ${height.toStringAsFixed(1)} cm\n'
                      'Age: $age\n'
                      'Activity Level: $activityLevelCalc\n'
                      'Base Calories: ${calories.toStringAsFixed(1)} kcal\n'
                      'Adjusted Calories: ${adjustedCalories.toStringAsFixed(1)} kcal\n'
                      'Final Calories: ${finalCalories.toStringAsFixed(1)} kcal',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Protein: ${protein.toStringAsFixed(1)} g/day\n'
                      'Carbs: ${carbs.toStringAsFixed(1)} g/day\n'
                      'Fat: ${fats.toStringAsFixed(1)} g/day',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const TitleWidget(title: 'Calories Chart'),
                    Flexible(
                      child: SfCircularChart(
                        enableMultiSelection: true,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            explode: true,

                            animationDuration: 1500, // Animation for pie chart
                            enableTooltip: true,
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.name,
                            yValueMapper: (ChartData data, _) =>
                                data.percentage,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataLabelMapper: (ChartData data, _) =>
                                '${data.name}\n'
                                '${data.percentage.toStringAsFixed(1)}%\n'
                                '${data.grams.toStringAsFixed(1)} g',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                            ),
                            selectionBehavior: SelectionBehavior(
                              enable: true,
                              selectedColor: Colors.purple,
                              unselectedColor: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    NutritionDetails()
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class ChartData {
  ChartData(this.name, this.percentage, this.color, this.grams);

  final String name;
  final double percentage;
  final Color color;
  final double grams;
}
