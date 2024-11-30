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

  Future<void> getgender() async {
    final prefs = await SharedPreferences.getInstance();
    final customGoal = prefs.getDouble('customGoal');
  }

  @override
  Widget build(BuildContext context) {
    // Data for the pie chart
    final List<ChartData> chartData = [
      ChartData('Protein', 30, Colors.blue),
      ChartData('Carbs', 20, Colors.green),
      ChartData('Fat', 50, Colors.orange),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleWidget(title: 'Calories Chart'),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .02,
        ),
        Expanded(
          child: SfCircularChart(
            // Enable chart animation
            enableMultiSelection: true,

            tooltipBehavior: TooltipBehavior(enable: true),
            // title: ChartTitle(
            //   text: 'Macronutrient Breakdown',
            //   textStyle: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              // Pie chart series
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
                    color:
                        Colors.white, // Adjust text color for better contrast
                    fontWeight: FontWeight.bold,
                  ),
                ),
                explode: true, // Emphasize each slice
                explodeOffset: '10%', // Offset for exploded slices
                startAngle: 0,
                endAngle: 360,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Model class for chart data
class ChartData {
  final String name;
  final double percentage;
  final Color color;

  ChartData(this.name, this.percentage, this.color);
}
