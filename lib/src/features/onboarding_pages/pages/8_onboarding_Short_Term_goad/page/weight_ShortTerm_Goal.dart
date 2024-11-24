import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
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
    List<TimeData> series1 = [
      TimeData(domain: DateTime(2024, 1), measure: 10),
      TimeData(domain: DateTime(2024, 2), measure: 20),
      TimeData(domain: DateTime(2024, 3), measure: 30),
      TimeData(domain: DateTime(2024, 4), measure: 50),
      TimeData(domain: DateTime(2024, 5), measure: 75),
      TimeData(domain: DateTime(2024, 6), measure: 55),
      TimeData(domain: DateTime(2024, 7), measure: 65),
      TimeData(domain: DateTime(2024, 8), measure: 58),
      TimeData(domain: DateTime(2024, 9), measure: 88),
      TimeData(domain: DateTime(2024, 10), measure: 50),
      TimeData(domain: DateTime(2024, 11), measure: 40),
      TimeData(domain: DateTime(2024, 12), measure: 48),
    ];

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartLineT(
        configRenderLine: ConfigRenderLine(
          strokeWidthPx: 2.5,
        ),
        layoutMargin: LayoutMargin(30, 10, 20, 10),
        domainAxis: DomainAxis(
          showLine: true,
          tickLength: 0,
          gapAxisToLabel: 10,
          tickLabelFormatterT: (domain) {
            return DateFormat('MMM').format(domain);
          },
          //that for months that in the bottom
          labelStyle: const LabelStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        //that for the grey lines not its false
        measureAxis: MeasureAxis(
          useGridLine: false,
          gridLineStyle: LineStyle(
            color: Colors.grey.shade200,
          ),
          numericTickProvider: const NumericTickProvider(
            desiredMinTickCount: 6,
            desiredMaxTickCount: 10,
          ),
          tickLength: 1,
          gapAxisToLabel: 10,
          tickLabelFormatter: (measure) {
            return measure!.toInt().toString().padLeft(2, '0');
          },
          labelStyle: const LabelStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        groupList: [
          TimeGroup(
            id: '1',
            data: series1,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
