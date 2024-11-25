import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/GoalCardList.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/TargetWeightInput.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/WeightGoalAppBar.dart';

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
        body: Padding(
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
              Expanded(child: const LineChart()),
            ],
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
        final String userGoal =
            state.userGoal; // "Lose Weight", "Gain Weight", "Maintain Weight"

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

        // Validate target weight based on goal
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

        // Calculate the number of weeks required to reach the target weight
        int weeks =
            ((currentWeight - targetWeight).abs() / weeklyChange).ceil();

        // Generate chart data for each week
        List<TimeData> chartData = List.generate(
          weeks,
          (index) => TimeData(
            domain: DateTime.now().add(Duration(days: index * 7)),
            measure: userGoal == "Lose Weight"
                ? (currentWeight - (index * weeklyChange))
                    .clamp(targetWeight, currentWeight)
                    .toDouble()
                : (currentWeight + (index * weeklyChange))
                    .clamp(currentWeight, targetWeight)
                    .toDouble(),
          ),
        );

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: DChartLineT(
            animate: true,
            configRenderLine: ConfigRenderLine(strokeWidthPx: 2.5),
            layoutMargin: LayoutMargin(30, 10, 20, 10),
            domainAxis: DomainAxis(
              showLine: true,
              tickLength: 5,
              gapAxisToLabel: 10,
              labelStyle: const LabelStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
              tickLabelFormatterT: (domain) {
                int weekIndex =
                    (domain.difference(DateTime.now()).inDays / 7).floor() + 1;
                return "Week $weekIndex: ${DateFormat('dd MMM').format(domain)}";
              },
            ),
            measureAxis: MeasureAxis(
              useGridLine: true,
              gridLineStyle: LineStyle(
                color: Colors.grey.shade200,
                dashPattern: [4, 2],
              ),
              numericTickProvider: const NumericTickProvider(
                desiredMinTickCount: 6,
                desiredMaxTickCount: 10,
              ),
              tickLabelFormatter: (measure) => context
                  .read<WeightGoalCubit>()
                  .formatWeight((measure ?? 0).toDouble()),
              labelStyle: const LabelStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            groupList: [
              TimeGroup(
                id: userGoal,
                data: chartData,
                color: userGoal == "Lose Weight" ? Colors.green : Colors.blue,
              ),
            ],
          ),
        );
      },
    );
  }
}
