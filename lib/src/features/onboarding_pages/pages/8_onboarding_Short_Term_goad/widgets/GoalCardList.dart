import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/GoalOptionCard.dart';

class GoalCardList extends StatelessWidget {
  final String? customGoal;
  final ValueChanged<String?> onCustomGoalUpdated;

  const GoalCardList({
    super.key,
    required this.customGoal,
    required this.onCustomGoalUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        return Center(
          child: Wrap(
            spacing: MediaQuery.sizeOf(context).width * .03,
            runSpacing: MediaQuery.sizeOf(context).width * .02,
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
              if (customGoal != null)
                GoalOptionCard(
                  title: "Lose $customGoal kg/week",
                  description: "Custom goal",
                  icon: Icons.edit,
                  isSelected: state.selectedOption == "Custom",
                  onTap: () =>
                      context.read<WeightGoalCubit>().selectOption("Custom"),
                  onDelete: () => onCustomGoalUpdated(null),
                  onEdit: () => _showCustomInputDialog(context),
                )
              else
                GoalOptionCard(
                  title: "Custom Goal",
                  description: "Set your own weekly goal",
                  icon: Icons.edit,
                  isSelected: state.selectedOption == "Custom",
                  onTap: () => _showCustomInputDialog(context),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomInputDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Custom Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your desired weekly weight loss goal (kg):",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "e.g., 0.75",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final input = controller.text;
                if (input.isNotEmpty) {
                  final customValue = double.tryParse(input);
                  if (customValue != null && customValue > 0) {
                    // Update the custom goal value in parent widget
                    onCustomGoalUpdated(customValue.toStringAsFixed(2));

                    // Set the custom goal and automatically select it
                    context
                        .read<WeightGoalCubit>()
                        .selectCustomOption(customValue);

                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid number."),
                      ),
                    );
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
