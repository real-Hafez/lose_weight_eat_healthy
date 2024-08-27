import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/WeightDisplayWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/toggle_buttons_widget.dart.dart';

class ThirdOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const ThirdOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<ThirdOnboardingPage> createState() => _ThirdOnboardingPageState();
}

class _ThirdOnboardingPageState extends State<ThirdOnboardingPage> {
  int _weightKg = 70; // Default weight in kg
  int _weightLb = 154; // Default weight in pounds
  String _weightUnit = 'kg'; // Default weight unit

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressIndicatorWidget(),
          const SizedBox(height: 20),
          const TitleWidget(
            title: 'What\'s your weight?',
          ),
          const SizedBox(height: 20),
          ToggleButtonsWidget(
            heightUnit: _weightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _weightUnit = unit;
                _updateWeightValues();
              });
            },
          ),
          const SizedBox(height: 20),
          WeightDisplayWidget(
            weightKg: _weightKg,
            weightLb: _weightLb,
            weightUnit: _weightUnit,
          ),
          Expanded(
            child: Center(
              child: _weightUnit == 'kg'
                  ? KgPicker(
                      weightKg: _weightKg,
                      onWeightChanged: (value) {
                        setState(() => _weightKg = value);
                      },
                    )
                  : LbPicker(
                      weightLb: _weightLb,
                      onWeightChanged: (value) {
                        setState(() => _weightLb = value);
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          NextButton(
            onPressed: widget.onNextButtonPressed,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _updateWeightValues() {
    if (_weightUnit == 'lb') {
      // Convert kg to pounds
      _weightLb = (_weightKg * 2.20462).round();
    } else {
      // Convert pounds to kg
      _weightKg = (_weightLb / 2.20462).round();
    }
  }
}
