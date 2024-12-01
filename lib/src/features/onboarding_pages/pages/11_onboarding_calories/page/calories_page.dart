import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatelessWidget {
  const CaloriesChart({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  // Fetching the goal from shared preferences
  Future<String> _getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getString('selected_goal') ?? 'No goal set';
    return goal; // Return the actual goal stored in preferences
  }

  // Fetching user data from shared preferences
  Future<Map<String, dynamic>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final gender = prefs.getString('gender') ?? 'Not set';
    final weight = prefs.getDouble('weightKg') ?? 0.0;
    final height = prefs.getDouble('heightCm') ?? 0.0;
    final age = prefs.getInt('age') ?? 0;

    // Retrieving and parsing activity level
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

  // Calculating calories based on gender
  double _calculateCalories(
      String gender, double weight, double height, int age) {
    gender = gender.toLowerCase();
    if (gender == 'man' || gender == 'male' || gender == 'ذكر') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (gender == 'woman' || gender == 'female' || gender == 'أنثى') {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      return 0.0; // Invalid gender fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    // Chart data
    final List<ChartData> chartData = [
      ChartData('Protein', 30, Colors.blue),
      ChartData('Carbs', 20, Colors.green),
      ChartData('Fat', 50, Colors.orange),
    ];

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

          return FutureBuilder<String>(
            future: _getGoal(),
            builder: (context, goalSnapshot) {
              final goal = goalSnapshot.data ?? 'No goal set';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender: $gender\n'
                    'Weight: ${weight.toStringAsFixed(1)} kg\n'
                    'Height: ${height.toStringAsFixed(1)} cm\n'
                    'Age: $age\n'
                    'Activity Level: $activityLevelCalc\n'
                    'Calories: ${calories.toStringAsFixed(1)} kcal\n'
                    'Final Calories: ${(calories * activityLevelCalc).toStringAsFixed(1)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Goal: $goal', // Display the exact goal here
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TitleWidget(title: 'Calories Chart'),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                  Expanded(
                    child: SfCircularChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.name,
                          yValueMapper: (ChartData data, _) => data.percentage,
                          pointColorMapper: (ChartData data, _) => data.color,
                          dataLabelMapper: (ChartData data, _) =>
                              '${data.name}\n${data.percentage}%',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          explode: true,
                          explodeOffset: '10%',
                          startAngle: 0,
                          endAngle: 360,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class ChartData {
  final String name;
  final double percentage;
  final Color color;

  ChartData(this.name, this.percentage, this.color);
}
