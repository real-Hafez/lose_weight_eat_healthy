import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/widget/NutritionDetails.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatelessWidget {
  const CaloriesChart({
    Key? key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  }) : super(key: key);

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CaloriesChartCubit()..loadCaloriesData()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<CaloriesChartCubit, CaloriesChartState>(
            builder: (context, state) {
              if (state is CaloriesChartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CaloriesChartError) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is CaloriesChartLoaded) {
                final finalCalories = state.finalCalories;
                final currentDiet = state.selectedDiet;

                // Diet macro distribution
                final dietMacroDistribution = {
                  "Balanced": {"protein": 0.25, "carbs": 0.45, "fat": 0.30},
                  "Low Fat": {"protein": 0.35, "carbs": 0.55, "fat": 0.10},
                  "Low Carb": {"protein": 0.30, "carbs": 0.10, "fat": 0.60},
                  "High Protein": {"protein": 0.40, "carbs": 0.40, "fat": 0.20},
                };

                final macroDistribution = dietMacroDistribution[currentDiet]!;

                // Calculate macros based on current diet
                final proteinCalories =
                    finalCalories * macroDistribution['protein']!;
                final carbCalories =
                    finalCalories * macroDistribution['carbs']!;
                final fatCalories = finalCalories * macroDistribution['fat']!;

                final protein =
                    (proteinCalories / 4).round(); // Rounded to nearest integer
                final carbs =
                    (carbCalories / 4).round(); // Rounded to nearest integer
                final fats =
                    (fatCalories / 9).round(); // Rounded to nearest integer
                final calories =
                    finalCalories.round(); // Rounded to nearest integer
                final bool isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';

                final chartData = [
                  ChartData(
                    '${S().Protein}',
                    (protein * 4 / finalCalories) * 100, // Keep as double
                    Colors.blue,
                  ),
                  ChartData(
                    '${S().Carbs}',
                    (carbs * 4 / finalCalories) * 100, // Keep as double
                    Colors.green,
                  ),
                  ChartData(
                    '${S().fats}',
                    (fats * 9 / finalCalories) * 100, // Keep as double
                    Colors.orange,
                  ),
                ];

                // Helper method for formatting numbers
                String formatPercentage(double value, bool isArabic) {
                  String percentage = value
                      .toStringAsFixed(1); // Convert to string with 1 decimal
                  return isArabic
                      ? NumberConversionHelper.convertToArabicNumbers(
                          percentage)
                      : percentage;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //     '${finalCalories.toStringAsFixed(0)} Calories ${state.activityLevel}${state.age}${state.gender}${state.macros}${state.weight}   ${state.height}         ${state.age}         '),
                    TitleWidget(title: '${S().CaloriesChart}'),
                    Flexible(
                      child: SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            explode: true,
                            animationDuration: 1500,
                            enableTooltip: true,
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.name,
                            yValueMapper: (ChartData data, _) =>
                                data.percentage,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataLabelMapper: (ChartData data, _) =>
                                '${data.name}\n${formatPercentage(data.percentage, isArabic)}%\n',
                            // '${data.grams.toStringAsFixed(1)} g',
                            dataLabelSettings: DataLabelSettings(
                              textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize:
                                      MediaQuery.sizeOf(context).height * .025),
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    NutritionDetails(
                      onDietSelected: (diet) {
                        // Update the selected diet in CaloriesChartCubit
                        context
                            .read<CaloriesChartCubit>()
                            .updateSelectedDiet(diet);
                      },
                    ),
                    NextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        // Save to Firestore via `NextButton`
                        onNextButtonPressed();

                        // Save to SharedPreferences
                        await prefs.setInt('proteinGrams', protein);
                        await prefs.setInt('carbsGrams', carbs);
                        await prefs.setInt('fatsGrams', fats);
                        await prefs.setInt('calories', finalCalories.round());

                        // Optional: Log or notify successful save
                        print('Data saved in SharedPreferences!');
                      },
                      collectionName: 'Cal',
                      dataToSave: {
                        'proteinGrams': protein,
                        'carbsGrams': carbs,
                        'fatsGrams': fats,
                        'calories': finalCalories.round(),
                      },
                      saveData: true,
                      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.name,
    this.percentage,
    this.color,
    //  this.grams
  );

  final String name;
  final double percentage;
  final Color color;
  // final int grams;
}
