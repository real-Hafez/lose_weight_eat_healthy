import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';

class TargetWeightInput extends StatefulWidget {
  const TargetWeightInput({super.key});

  @override
  State<TargetWeightInput> createState() => _TargetWeightInputState();
}

class _TargetWeightInputState extends State<TargetWeightInput> {
  late TextEditingController _controller;
  bool _isRecommended = true;
  String? _validationMessage;

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
        final weightCubit = context.read<WeightGoalCubit>();

        // Parse and convert healthy weight range
        final minWeightKg =
            double.tryParse(state.minWeight.split(' ').first) ?? 0.0;
        final maxWeightKg = double.tryParse(state.maxWeight.split(' ').first) ??
            double.infinity;

        final minWeight =
            state.weightUnit == 'lb' ? minWeightKg * 2.20462 : minWeightKg;
        final maxWeight =
            state.weightUnit == 'lb' ? maxWeightKg * 2.20462 : maxWeightKg;

        String formattedMinWeight = minWeight.toStringAsFixed(1);
        String formattedMaxWeight = maxWeight.toStringAsFixed(1);

        // Convert numbers to Arabic if the language is Arabic
        if (Localizations.localeOf(context).languageCode == 'ar') {
          formattedMinWeight =
              NumberConversionHelper.convertToArabicNumbers(formattedMinWeight);
          formattedMaxWeight =
              NumberConversionHelper.convertToArabicNumbers(formattedMaxWeight);
        }

        // Set initial target weight in the correct unit
        if (_isRecommended && state.targetWeight != 'Invalid height') {
          final targetWeight =
              double.tryParse(state.targetWeight.split(' ').first) ?? 0.0;
          final displayWeight =
              state.weightUnit == 'lb' ? targetWeight * 2.20462 : targetWeight;
          _controller.text = displayWeight.toStringAsFixed(1);
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
        String weightUnit = S().kg;
        if (state.weightUnit == 'kg') {
          weightUnit = S().kg;
        } else {
          weightUnit = S().lb;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S().TargetWeight,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * .03,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${S().Healthyrange} $formattedMinWeight - $formattedMaxWeight $weightUnit',
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * .025,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height * .025),
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,1}')),
                    ],
                    decoration: InputDecoration(
                      hintText: state.targetWeight == 'Invalid height'
                          ? 'Enter a valid height first'
                          : null,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: state.targetWeight == 'Invalid height'
                            ? Colors.red
                            : Colors.grey.shade600,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      errorText: _validationMessage,
                    ),
                    onChanged: (value) {
                      if (_isRecommended) _isRecommended = false;

                      final inputWeight = double.tryParse(value) ?? 0.0;
                      final inputWeightKg = state.weightUnit == 'lb'
                          ? inputWeight / 2.20462
                          : inputWeight;

                      if (inputWeightKg < minWeightKg ||
                          inputWeightKg > maxWeightKg) {
                        setState(() {
                          _validationMessage =
                              '${S().rangeweight} $formattedMinWeight - $formattedMaxWeight $weightUnit .';
                        });
                      } else {
                        setState(() {
                          _validationMessage = null;
                        });
                      }

                      weightCubit.updateTargetWeight(inputWeightKg.toString());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  weightUnit,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            // if (_validationMessage != null)
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Text(
            //     _validationMessage!,
            //     style: const TextStyle(
            //       color: Colors.red,
            //       fontSize: 12,
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
