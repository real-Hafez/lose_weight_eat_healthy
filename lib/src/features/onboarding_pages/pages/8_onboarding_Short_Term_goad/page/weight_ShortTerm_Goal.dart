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
        final double weeklyLoss = state.selectedOption == "Lose 1 kg/week"
            ? 1.0
            : state.selectedOption == "Lose 0.5 kg/week"
                ? 0.5
                : state.customGoal ?? 1.0;

        // Ensure weeklyLoss is positive to avoid infinite loops
        if (weeklyLoss <= 0) {
          return const Center(
            child: Text("Invalid weekly loss. Please set a valid goal."),
          );
        }

        // Calculate the number of weeks
        int weeks = ((currentWeight - targetWeight) / weeklyLoss).ceil();

        // Handle invalid cases where targetWeight > currentWeight
        if (weeks < 0) {
          return const Center(
            child: Text("Target weight must be less than your current weight."),
          );
        }

        // Generate chart data
        List<TimeData> chartData = List.generate(
          weeks,
          (index) => TimeData(
            domain: DateTime.now().add(Duration(days: index * 7)),
            measure: (currentWeight - (index * weeklyLoss))
                .clamp(targetWeight, currentWeight),
          ),
        );

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: DChartLineT(
            configRenderLine: ConfigRenderLine(strokeWidthPx: 2.5),
            layoutMargin: LayoutMargin(30, 10, 20, 10),
            domainAxis: DomainAxis(
              showLine: true,
              tickLength: 0,
              gapAxisToLabel: 10,
              tickLabelFormatterT: (domain) {
                return DateFormat('MMM d').format(domain);
              },
              labelStyle: const LabelStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            measureAxis: MeasureAxis(
              useGridLine: false,
              gridLineStyle: LineStyle(
                color: Colors.grey.shade200,
              ),
              numericTickProvider: const NumericTickProvider(
                desiredMinTickCount: 6,
                desiredMaxTickCount: 10,
              ),
              tickLabelFormatter: (measure) => measure!.toInt().toString(),
              labelStyle: const LabelStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            groupList: [
              TimeGroup(
                id: 'Weight Loss',
                data: chartData,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}
