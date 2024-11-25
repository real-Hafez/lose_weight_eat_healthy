import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';

class TargetWeightInput extends StatefulWidget {
  const TargetWeightInput({super.key});

  @override
  State<TargetWeightInput> createState() => _TargetWeightInputState();
}

class _TargetWeightInputState extends State<TargetWeightInput> {
  late TextEditingController _controller;
  bool _isRecommended = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightGoalCubit, WeightGoalState>(
      builder: (context, state) {
        if (_isRecommended && state.targetWeight != 'Invalid height') {
          _controller.text = state.targetWeight;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }

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
            Stack(
              children: [
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: state.targetWeight == 'Invalid height'
                        ? 'Enter a valid height first'
                        : null,
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
                    if (_isRecommended) {
                      _isRecommended = false;
                    }
                    context.read<WeightGoalCubit>().updateTargetWeight(value);
                  },
                ),
                if (_isRecommended && state.targetWeight != 'Invalid height')
                  Positioned(
                    right: 8,
                    top: 12,
                    child: Text(
                      '★ Recommended',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
