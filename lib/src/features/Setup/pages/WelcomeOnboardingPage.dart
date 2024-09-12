import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class WelcomeOnboardingPage extends StatelessWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WelcomeOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedTextWidget(
              onFinished: onAnimationFinished,
              text: S.of(context).welcomeonboarding),
        ),
        NextButton(
          
          collectionName: 'next',
          onPressed: onNextButtonPressed,
          dataToSave: const {},
          saveData: false,
        )
      ],
    );
  }
}
