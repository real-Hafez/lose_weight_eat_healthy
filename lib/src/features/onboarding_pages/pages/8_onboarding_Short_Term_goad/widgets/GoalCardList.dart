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
        final unit = state.weightUnit;
        final userGoal = state.userGoal;
        final isLoseWeight = userGoal == "Lose Weight";
        final isGainWeight = userGoal == "Gain Weight";

        return Center(
          child: Wrap(
            spacing: MediaQuery.sizeOf(context).width * 0.03,
            runSpacing: MediaQuery.sizeOf(context).width * 0.02,
            alignment: WrapAlignment.center,
            children: [
              if (userGoal == "Maintain Weight")
                GoalOptionCard(
                  title: "Maintain Current Weight",
                  description: "Stay at your current weight.",
                  icon: Icons.balance,
                  isSelected: state.selectedOption == "Maintain Weight",
                  onTap: () => context
                      .read<WeightGoalCubit>()
                      .selectOption("Maintain Weight"),
                )
              else ...[
                _buildGoalOption(
                  context: context,
                  title:
                      "${isLoseWeight ? "Lose" : "Gain"} ${context.read<WeightGoalCubit>().formatWeeklyLoss(0.5)}",
                  description:
                      "Gradual ${isLoseWeight ? "weight loss" : "weight gain"}",
                  icon: isLoseWeight
                      ? Icons.hourglass_bottom
                      : Icons.arrow_upward,
                  isSelected: state.selectedOption ==
                      "${isLoseWeight ? "Lose" : "Gain"} 0.5",
                  value: "${isLoseWeight ? "Lose" : "Gain"} 0.5",
                ),
                _buildGoalOption(
                  context: context,
                  title:
                      "${isLoseWeight ? "Lose" : "Gain"} ${context.read<WeightGoalCubit>().formatWeeklyLoss(1.0)}",
                  description:
                      "Faster ${isLoseWeight ? "weight loss" : "weight gain"}",
                  icon: isLoseWeight
                      ? Icons.flash_on
                      : Icons.arrow_upward_outlined,
                  isSelected: state.selectedOption ==
                      "${isLoseWeight ? "Lose" : "Gain"} 1.0",
                  value: "${isLoseWeight ? "Lose" : "Gain"} 1.0",
                ),
                _buildCustomGoalOption(context, state),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required String value,
  }) {
    return GoalOptionCard(
      title: title,
      description: description,
      icon: icon,
      isSelected: isSelected,
      onTap: () => context.read<WeightGoalCubit>().selectOption(value),
    );
  }

  Widget _buildCustomGoalOption(BuildContext context, WeightGoalState state) {
    final unit = state.weightUnit;
    final isLoseWeight = state.userGoal == "Lose Weight";

    return customGoal != null
        ? GoalOptionCard(
            title: "${isLoseWeight ? "Lose" : "Gain"} $customGoal $unit/week",
            description: "Custom goal",
            icon: Icons.edit,
            isSelected: state.selectedOption == "Custom",
            onTap: () => context.read<WeightGoalCubit>().selectOption("Custom"),
            onDelete: () => onCustomGoalUpdated(null),
            onEdit: () => _showCustomInputDialog(context, state),
          )
        : GoalOptionCard(
            title: "Custom Goal",
            description: "Set your own weekly goal.",
            icon: Icons.edit,
            isSelected: state.selectedOption == "Custom",
            onTap: () => _showCustomInputDialog(context, state),
          );
  }

  void _showCustomInputDialog(BuildContext context, WeightGoalState state) {
    final controller = TextEditingController();
    final unit = state.weightUnit;
    final isLoseWeight = state.userGoal == "Lose Weight";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Custom Goal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter your desired weekly ${isLoseWeight ? "weight loss" : "weight gain"} goal ($unit):",
                style: const TextStyle(fontSize: 14),
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
                    if ((unit == "kg" && customValue <= 1.5) ||
                        (unit == "lb" && customValue <= 3.3)) {
                      onCustomGoalUpdated(customValue.toStringAsFixed(2));
                      context
                          .read<WeightGoalCubit>()
                          .selectCustomOption(customValue);
                      Navigator.of(context).pop();
                    } else {
                      _showSnackBar(context,
                          "A weekly goal of more than ${unit == "kg" ? "1.5 kg" : "3.3 lb"} is not healthy.");
                    }
                  } else {
                    _showSnackBar(context, "Please enter a valid number.");
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
