import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';

class TargetWeightInput extends StatelessWidget {
  const TargetWeightInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
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
              initialValue: null,
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
                context.read<WeightGoalCubit>().updateTargetWeight(value);
              },
            ),
          ],
        );
      },
    );
  }
}
