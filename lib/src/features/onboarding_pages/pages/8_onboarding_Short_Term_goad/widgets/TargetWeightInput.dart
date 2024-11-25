import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // For input formatters
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
  String? _validationMessage; // To store the validation message

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
        // Update the controller text with the recommended target weight
        if (_isRecommended && state.targetWeight != 'Invalid height') {
          _controller.text = state.targetWeight;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }

        // Parse the healthy weight range
        final minWeight =
            double.tryParse(state.minWeight.split(' ').first) ?? 0.0;
        final maxWeight = double.tryParse(state.maxWeight.split(' ').first) ??
            double.infinity;

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
            Text(
              'Healthy range: ${context.read<WeightGoalCubit>().formatWeight(minWeight)} - ${context.read<WeightGoalCubit>().formatWeight(maxWeight)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^\d*\.?\d{0,1}')), // Restrict to numbers with one decimal
                    ],
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
                      errorText:
                          _validationMessage, // Display validation message
                    ),
                    onChanged: (value) {
                      if (_isRecommended) {
                        _isRecommended = false;
                      }
                      final inputWeight = double.tryParse(value) ?? 0.0;

                      // Validate if the input weight is within the healthy range
                      if (inputWeight < minWeight || inputWeight > maxWeight) {
                        setState(() {
                          _validationMessage =
                              'Please enter a weight within the range ${state.minWeight} - ${state.maxWeight}.';
                        });
                      } else {
                        setState(() {
                          _validationMessage = null; // Clear the message
                        });
                      }

                      // Update the cubit state with the new target weight
                      context.read<WeightGoalCubit>().updateTargetWeight(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  state.weightUnit, // Display the weight unit (kg/lbs)
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            if (_validationMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _validationMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
