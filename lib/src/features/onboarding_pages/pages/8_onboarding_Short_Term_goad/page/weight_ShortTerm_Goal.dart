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
        return Center(
          child: Wrap(
            spacing: 16, // Horizontal spacing
            runSpacing: 16, // Vertical spacing
            alignment: WrapAlignment.center,
            children: [
              GoalOptionCard(
                title: "Lose 0.5 kg/week",
                description: "Gradual weight loss",
                icon: Icons.hourglass_bottom,
                isSelected: state.selectedOption == "Lose 0.5 kg/week",
                onTap: () => context
                    .read<WeightGoalCubit>()
                    .selectOption("Lose 0.5 kg/week"),
              ),
              GoalOptionCard(
                title: "Lose 1 kg/week",
                description: "Faster weight loss",
                icon: Icons.flash_on,
                isSelected: state.selectedOption == "Lose 1 kg/week",
                onTap: () => context
                    .read<WeightGoalCubit>()
                    .selectOption("Lose 1 kg/week"),
              ),
              GoalOptionCard(
                title: "Custom",
                description: "Set your own goal",
                icon: Icons.edit,
                isSelected: state.selectedOption == "Custom",
                onTap: () =>
                    context.read<WeightGoalCubit>().selectOption("Custom"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GoalOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
