import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/widget/NutritionDetails.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
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

                final protein = proteinCalories / 4;
                final carbs = carbCalories / 4;
                final fats = fatCalories / 9;

                final chartData = [
                  ChartData('Protein', (protein * 4 / finalCalories) * 100,
                      Colors.blue, protein),
                  ChartData('Carbs', (carbs * 4 / finalCalories) * 100,
                      Colors.green, carbs),
                  ChartData('Fat', (fats * 9 / finalCalories) * 100,
                      Colors.orange, fats),
                ];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //     '${finalCalories.toStringAsFixed(0)} Calories ${state.activityLevel}${state.age}${state.gender}${state.macros}${state.weight}   ${state.height}         ${state.age}         '),
                    const TitleWidget(title: 'Calories Chart'),
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
                                '${data.name}\n${data.percentage.toStringAsFixed(1)}%\n${data.grams.toStringAsFixed(1)} g',
                            dataLabelSettings: const DataLabelSettings(
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
  ChartData(this.name, this.percentage, this.color, this.grams);

  final String name;
  final double percentage;
  final Color color;
  final double grams;
}
