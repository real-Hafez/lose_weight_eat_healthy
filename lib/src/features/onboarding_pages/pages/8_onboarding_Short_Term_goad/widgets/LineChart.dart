import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  const LineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        if (state.selectedOption == null || state.selectedOption == "") {
          return const Center(
            child: Text("Set your target weight to view the chart."),
          );
        }

        final double currentWeight = state.weightKg!;
        final double targetWeight =
            double.tryParse(state.targetWeight!) ?? currentWeight;
        final double minWeight =
            double.tryParse(state.minWeight.split(' ').first) ?? 0.0;
        final double maxWeight =
            double.tryParse(state.maxWeight.split(' ').first) ??
                double.infinity;
        final String userGoal = state.userGoal;
        final String weightUnit =
            state.weightUnit ?? 'kg'; // Default to kg if unit is null

        // Function to convert weight to pounds if the unit is 'lb'
        double convertWeight(double weight) {
          return weightUnit == 'lb' ? weight * 2.20462 : weight;
        }

        // Check if the target weight is within the allowed range
        if (convertWeight(targetWeight) < convertWeight(minWeight)) {
          return Center(
            child: Text(
              "${S().belowweigh} ${convertWeight(minWeight).toStringAsFixed(1)} $weightUnit. ${S().highertarget}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        } else if (convertWeight(targetWeight) > convertWeight(maxWeight)) {
          return Center(
            child: Text(
              "${S().maxweigh} ${convertWeight(maxWeight).toStringAsFixed(1)} $weightUnit. ${S().lowertarget}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }

        final double weeklyChange = state.selectedOption == "Lose 1.0" ||
                state.selectedOption == "Gain 1.0"
            ? 1.0
            : state.selectedOption == "Lose 0.5" &&
                    state.selectedOption == "Gain 0.5"
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
          fullChartData
              .add(TimeData(domain: date, measure: convertWeight(weight)));
        }

        // Ensure exactly 5 data points are selected
        List<TimeData> chartData = [];
        if (fullChartData.length <= 5) {
          chartData = fullChartData;
        } else {
          for (int i = 0; i < 5; i++) {
            int index = (i * (fullChartData.length - 1) ~/ 4);
            chartData.add(fullChartData[index]);
          }
        }
        String weight_unit = S().kg;
        if (state.weightUnit == 'kg') {
          weight_unit = '${S().kg}';
        } else {
          weight_unit = '${S().lb}';
        }
        return Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  minimum: chartData.first.domain,
                  maximum: chartData.last.domain,
                  intervalType: DateTimeIntervalType.days,
                  interval: chartData.length > 1
                      ? chartData[1]
                          .domain
                          .difference(chartData[0].domain)
                          .inDays
                          .toDouble()
                      : 1,
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.none,
                  labelStyle: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * .02,
                      color: Colors.grey),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                    dashArray: [4, 2],
                    color: Colors.grey.shade300,
                  ),
                  labelFormat: '{value} $weight_unit',
                  labelStyle: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * .02,
                      color: Colors.grey),
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    // Check the current locale
                    final isArabic =
                        Localizations.localeOf(context).languageCode == 'ar';

                    // If Arabic, convert the number to Arabic numerals
                    return ChartAxisLabel(
                      isArabic
                          ? NumberConversionHelper.convertToArabicNumbers(
                              details.text)
                          : details.text,
                      TextStyle(
                          fontSize: MediaQuery.sizeOf(context).height * .02,
                          color: Colors.grey),
                    );
                  },
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x: point.y $weightUnit',
                ),
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
                    width: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AutoSizeText(
                maxFontSize: 42,
                minFontSize: 8,
                maxLines: 1,
                () {
                  final int totalDays = chartData.last.domain
                      .difference(chartData.first.domain)
                      .inDays;
                  final int totalWeeks = (totalDays / 7).floor();

                  // here from 1 week to 22 week show the text in weeks
                  if (totalWeeks <= 22) {
                    return "${S().Estimatedtime} $totalWeeks ${S().week}${totalWeeks > 1 ? '${S().s}' : ''}";
                  } else {
                    //here from 22 weeks to 12 months show the msg in monthes
                    final int totalMonths = (totalWeeks / 4)
                        .floor(); // Convert weeks to months (4 weeks per month approx.)
                    if (totalMonths > 12) {
                      //here if more that 12 mon
                      return "${S().Yourjourney}";
                    }
                    return "${S().Estimatedtime} $totalMonths ${S().month}${totalMonths > 1 ? '${S().s}' : ''}";
                  }
                }(),
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
