import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/calories_chart_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/11_onboarding_calories/cubit/cubit/nutrition_details_cubit_cubit.dart';
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
    return BlocProvider(
      create: (_) => CaloriesChartCubit()..loadCaloriesData(),
      child: BlocBuilder<CaloriesChartCubit, CaloriesChartState>(
        builder: (context, state) {
          if (state is CaloriesChartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CaloriesChartError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is CaloriesChartLoaded) {
            final macros = state.macros;
            final protein = macros['Protein']!;
            final carbs = macros['Carbs']!;
            final fats = macros['Fat']!;
            final totalMacros = protein + carbs + fats;

            final chartData = [
              ChartData('Protein', (protein / totalMacros) * 100, Colors.blue,
                  protein),
              ChartData(
                  'Carbs', (carbs / totalMacros) * 100, Colors.green, carbs),
              ChartData('Fat', (fats / totalMacros) * 100, Colors.orange, fats),
            ];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${state.finalCalories}'),
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
                        yValueMapper: (ChartData data, _) => data.percentage,
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
                BlocProvider.value(
                  value: context.read<NutritionCubit>()
                    ..updateTotalCalories(state.finalCalories),
                  child: NutritionDetails(),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
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
