import 'package:d_chart/d_chart.dart';
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
        final DateTime endDate = startDate.add(Duration(days: totalWeeks * 7));

        List<DateTime> keyDates = List.generate(
          6,
          (index) => startDate.add(
            Duration(days: (index * totalWeeks ~/ 5) * 7),
          ),
        );
        keyDates[5] = endDate; // Ensure the last date is the end date.

        List<TimeData> chartData = [];
        for (int i = 0; i <= totalWeeks; i++) {
          DateTime date = startDate.add(Duration(days: i * 7));
          double weight = userGoal == "Lose Weight"
              ? (currentWeight - (i * weeklyChange))
                  .clamp(targetWeight, currentWeight)
                  .toDouble()
              : (currentWeight + (i * weeklyChange))
                  .clamp(currentWeight, targetWeight)
                  .toDouble();
          chartData.add(TimeData(domain: date, measure: weight));
        }

        return Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  interval: 1,
                  dateFormat: DateFormat('dd MMM'),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                    dashArray: [4, 2],
                    color: Colors.grey.shade200,
                  ),
                  labelFormat: '{value} kg',
                  labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <LineSeries<TimeData, DateTime>>[
                  LineSeries<TimeData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data.domain,
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
                    width: 2.5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: keyDates.map((date) {
                bool isLastDate = date == keyDates.last;
                return Column(
                  children: [
                    Text(
                      DateFormat('dd MMM').format(date),
                      style: TextStyle(
                        fontWeight:
                            isLastDate ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                        color: isLastDate ? Colors.red : Colors.grey.shade700,
                      ),
                    ),
                    if (isLastDate)
                      const Text(
                        "Last Month",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                );
              }).toList(),
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
