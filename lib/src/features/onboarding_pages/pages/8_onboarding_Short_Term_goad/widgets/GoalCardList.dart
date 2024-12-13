import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/widgets/GoalOptionCard.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';

class GoalCardList extends StatefulWidget {
  final String? customGoal;
  final ValueChanged<String?> onCustomGoalUpdated;

  const GoalCardList({
    super.key,
    required this.customGoal,
    required this.onCustomGoalUpdated,
  });

  @override
  _GoalCardListState createState() => _GoalCardListState();
}

class _GoalCardListState extends State<GoalCardList> {
  @override
  void initState() {
    super.initState();
    _loadSelectedGoal();
  }

  Future<void> _loadSelectedGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedGoal = prefs.getString('selected_goal');
    if (selectedGoal != null) {
      context.read<WeightGoalCubit>().selectOption(selectedGoal);
    }
  }

  Future<void> _saveSelectedGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_goal', goal);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        final locale = Localizations.localeOf(context);
        final isArabic = locale.languageCode == 'ar';

        final unit = state.weightUnit;
        final userGoal = state.userGoal;
        final isLoseWeight = userGoal == "Lose Weight";
        String convertNumber(String input) => isArabic
            ? NumberConversionHelper.convertToArabicNumbers(input)
            : input;

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
                  onTap: () async {
                    await _saveSelectedGoal("Maintain Weight");
                    context
                        .read<WeightGoalCubit>()
                        .selectOption("Maintain Weight");
                  },
                )
              else ...[
                _buildGoalOption(
                  context: context,
                  title:
                      "${isLoseWeight ? S().lose : S().gain} ${convertNumber(context.read<WeightGoalCubit>().formatWeeklyLoss(0.5))}",
                  description:
                      "${S().Gradual} ${isLoseWeight ? S().WeightLoss : S().weightgain}",
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
                      "${isLoseWeight ? S().lose : S().gain} ${convertNumber(context.read<WeightGoalCubit>().formatWeeklyLoss(1.0))}",
                  description:
                      "${S().Faster} ${isLoseWeight ? S().WeightLoss : S().weightgain}",
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
      onTap: () async {
        await _saveSelectedGoal(value);
        context.read<WeightGoalCubit>().selectOption(value);
      },
    );
  }

  Widget _buildCustomGoalOption(BuildContext context, WeightGoalState state) {
    final unit = state.weightUnit;
    final isLoseWeight = state.userGoal == "Lose Weight";
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return widget.customGoal != null
        ? GoalOptionCard(
            title:
                "${isLoseWeight ? S().lose : S().gain} ${isArabic ? NumberConversionHelper.convertToArabicNumbers(widget.customGoal ?? "") : widget.customGoal} ${isArabic ? NumberConversionHelper.convertToArabicNumbers(unit) : unit}/${S().week}",
            description: S().customgoal,
            icon: Icons.edit,
            isSelected: state.selectedOption == "Custom",
            onTap: () async {
              await _saveSelectedGoal("Custom");
              context.read<WeightGoalCubit>().selectOption("Custom");
            },
            onDelete: () => widget.onCustomGoalUpdated(null),
            onEdit: () => _showCustomInputDialog(context, state),
          )
        : GoalOptionCard(
            title: S().customgoal,
            description: S().weeklygoal,
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
          title: Text(S().customgoal),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${S().desiredweekly} ${isLoseWeight ? S().lose : S().gain} ${S().Goal} ($unit):",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: S().ex,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S().Cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final input = controller.text;
                if (input.isNotEmpty) {
                  final customValue = double.tryParse(input);
                  if (customValue != null && customValue > 0) {
                    if ((unit == "kg" &&
                            customValue <= 1.5 &&
                            customValue >= 0.1) ||
                        (unit == "lb" &&
                            customValue <= 3.3 &&
                            customValue >= 0.2)) {
                      widget
                          .onCustomGoalUpdated(customValue.toStringAsFixed(2));
                      context
                          .read<WeightGoalCubit>()
                          .selectCustomOption(customValue);
                      _saveSelectedGoal("Custom");
                      Navigator.of(context).pop();
                    } else {
                      _showSnackBar(context, S().validgoal);
                    }
                  } else {
                    _showSnackBar(context, S().vaildnumber);
                  }
                }
              },
              child: Text(S().Save),
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
