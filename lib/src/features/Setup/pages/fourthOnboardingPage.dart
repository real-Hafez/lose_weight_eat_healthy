import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ToggleButtonsWidgetkg.dart';

class fourthOnboardingPage extends StatelessWidget {
  const fourthOnboardingPage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressIndicatorWidget(
          value: 0.6,
        ),
        const SizedBox(height: 20),
        const TitleWidget(title: 'Your Cureent BMI'),
        const SizedBox(height: 20),
        ToggleButtonsWidgetkg(
          weightUnit: _weightUnit,
          onUnitChanged: (unit) {
            setState(() {
              _weightUnit = unit;
              _updateWeightValues();
            });
          },
        ),
      ],
    );
  }
}
