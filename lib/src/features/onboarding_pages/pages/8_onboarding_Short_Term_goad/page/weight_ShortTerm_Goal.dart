import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/GoalCardList.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/TargetWeightInput.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/WeightGoalAppBar.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightGoalPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WeightGoalPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  _WeightGoalPageState createState() => _WeightGoalPageState();
}

class _WeightGoalPageState extends State<WeightGoalPage> {
  String? customGoal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightGoalCubit()..loadPreferences(),
      child: Scaffold(
        appBar: const WeightGoalAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TargetWeightInput(),
                const SizedBox(height: 16),
                GoalCardList(
                  customGoal: customGoal,
                  onCustomGoalUpdated: (newCustomGoal) {
                    setState(() {
                      customGoal = newCustomGoal;
                    });
                  },
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 8 / 9,
                  child: const LineChart(),
                ),
                const SizedBox(height: 24),
                NextButton(
                  onPressed: widget.onNextButtonPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        if (state.targetWeight == null || state.weightKg == null) {
          return const Center(
            child: Text("Set your target weight to view the chart."),
          );
        }

        final double currentWeight = state.weightKg!;
        final double targetWeight =
            double.tryParse(state.targetWeight!) ?? currentWeight;
        final String userGoal = state.userGoal;

        final double weeklyChange = state.selectedOption == "Lose 1 kg/week"
            ? 1.0
            : state.selectedOption == "Lose 0.5 kg/week"
                ? 0.5
                : state.customGoal ?? 1.0;

        if (weeklyChange <= 0) {
          return const Center(
            child: Text("Invalid weekly goal. Please set a valid goal."),
          );
        }

        if ((userGoal == "Lose Weight" && targetWeight >= currentWeight) ||
            (userGoal == "Gain Weight" && targetWeight <= currentWeight)) {
          return Center(
            child: Text(
              "For a ${userGoal.toLowerCase()}, your target weight must be ${userGoal == "Lose Weight" ? "less" : "greater"} than your current weight.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }

        final int totalWeeks =
            ((currentWeight - targetWeight).abs() / weeklyChange).ceil();
        final DateTime startDate = DateTime.now();

        // Generate chart data for all weeks
        List<TimeData> fullChartData = [];
        for (int i = 0; i <= totalWeeks; i++) {
          DateTime date = startDate.add(Duration(days: i * 7));
          double weight = userGoal == "Lose Weight"
              ? (currentWeight - (i * weeklyChange))
                  .clamp(targetWeight, currentWeight)
                  .toDouble()
              : (currentWeight + (i * weeklyChange))
                  .clamp(currentWeight, targetWeight)
                  .toDouble();
          fullChartData.add(TimeData(domain: date, measure: weight));
        }

        // Ensure exactly 5 data points are selected
        List<TimeData> chartData = [];
        if (fullChartData.length <= 5) {
          // If 5 or fewer points, use all
          chartData = fullChartData;
        } else {
          // Select 5 evenly spaced points
          for (int i = 0; i < 5; i++) {
            int index = (i * (fullChartData.length - 1) ~/ 4);
            chartData.add(fullChartData[index]);
          }
        }

        // Create custom axis labels that match the exact dates of data points
        List<String> customXAxisLabels = chartData
            .map((data) => DateFormat('d MMM').format(data.domain))
            .toList();

        return Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  // Ensure the axis matches the range of your data points
                  minimum: chartData.first.domain,
                  maximum: chartData.last.domain,
                  intervalType: DateTimeIntervalType
                      .days, // Adjust based on your intervals
                  interval: chartData.length > 1
                      ? chartData[1]
                          .domain
                          .difference(chartData[0].domain)
                          .inDays
                          .toDouble()
                      : 1,
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.none,
                  labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  // Use only the exact data point labels
                  majorTickLines: const MajorTickLines(size: 0),
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final DateTime labelDate =
                        DateTime.fromMillisecondsSinceEpoch(
                            details.value.toInt());
                    return ChartAxisLabel(
                      DateFormat('d MMM').format(labelDate),
                      const TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  },
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                    dashArray: [4, 2],
                    color: Colors.grey.shade300,
                  ),
                  labelFormat: '{value} kg',
                  labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x: point.y kg',
                ),
                series: <LineSeries<TimeData, DateTime>>[
                  LineSeries<TimeData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (data, _) =>
                        data.domain as DateTime, // Ensure casting to DateTime
                    yValueMapper: (data, _) => data.measure,
                    color:
                        userGoal == "Lose Weight" ? Colors.green : Colors.blue,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      color: Colors.red,
                    ),
                    width: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Projected timeline to reach your target weight: ${DateFormat('d MMM yyyy').format(chartData.last.domain)}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TimeData {
  final DateTime domain;
  final double measure;

  TimeData({required this.domain, required this.measure});
}
