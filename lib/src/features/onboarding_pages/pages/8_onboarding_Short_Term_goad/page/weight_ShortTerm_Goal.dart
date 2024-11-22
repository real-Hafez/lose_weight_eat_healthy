import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';

class WeightGoalPage extends StatelessWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WeightGoalPage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightGoalCubit()..loadPreferences(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<WeightGoalCubit, WeightGoalState>(
            builder: (context, state) => Text(
              '${state.userGoal} Goal',
              style: const TextStyle(fontFamily: 'Indie_Flower'),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<WeightGoalCubit, WeightGoalState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Weight',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: null, // User starts with an empty field
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: state.targetWeight == 'Invalid height'
                              ? 'Enter a valid height first'
                              : 'Recommended: ${state.targetWeight} ',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: state.targetWeight == 'Invalid height'
                                ? Colors.red
                                : Colors.grey.shade600,
                          ),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        onChanged: (value) {
                          context
                              .read<WeightGoalCubit>()
                              .updateTargetWeight(value);
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              UserTargetOptions(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTargetOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoalOptionCard(
              title: "Lose 0.5 kg/week",
              description: "",
              isSelected: state.selectedOption == "Lose 0.5 kg/week",
              onTap: () => context
                  .read<WeightGoalCubit>()
                  .selectOption("Lose 0.5 kg/week"),
            ),
            const SizedBox(height: 16),
            GoalOptionCard(
              title: "Lose 1 kg/week",
              description: "",
              isSelected: state.selectedOption == "Lose 1 kg/week",
              onTap: () => context
                  .read<WeightGoalCubit>()
                  .selectOption("Lose 1 kg/week"),
            ),
            const SizedBox(height: 16),
            GoalOptionCard(
              title: "Custom",
              description: "",
              isSelected: state.selectedOption == "Custom",
              onTap: () =>
                  context.read<WeightGoalCubit>().selectOption("Custom"),
            ),
          ],
        );
      },
    );
  }
}

class GoalOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalOptionCard({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
