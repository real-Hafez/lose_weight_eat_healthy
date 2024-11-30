import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatelessWidget {
  const CaloriesChart(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    // Data for the pie chart
    final List<ChartData> chartData = [
      ChartData('Protein', 30, Colors.blue),
      ChartData('Carbs', 20, Colors.green),
      ChartData('Fat', 50, Colors.orange),
    ];

    return SfCircularChart(
      title: ChartTitle(text: 'Macronutrient Distribution'),
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
          dataLabelMapper: (ChartData data, _) => '${data.percentage}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
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
