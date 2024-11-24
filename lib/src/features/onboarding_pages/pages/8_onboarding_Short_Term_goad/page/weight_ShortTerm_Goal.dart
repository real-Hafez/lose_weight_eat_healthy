import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
