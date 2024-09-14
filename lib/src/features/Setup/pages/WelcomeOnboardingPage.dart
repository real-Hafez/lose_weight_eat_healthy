import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class WelcomeOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WelcomeOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<WelcomeOnboardingPage> createState() => _WelcomeOnboardingPageState();
}

class _WelcomeOnboardingPageState extends State<WelcomeOnboardingPage> {
  bool _showNextButton = false;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() {
    Future.delayed(const Duration(seconds: 13)).then((_) {
      if (mounted) {
        setState(() {
          _showNextButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressIndicatorWidget(value: 0.1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedTextWidget(
            onFinished: widget.onAnimationFinished,
            text: S.of(context).welcomeonboarding,
          ),
        ),
        _showNextButton
            ? NextButton(
                collectionName: 'next',
                onPressed: widget.onNextButtonPressed,
                dataToSave: const {},
                saveData: false,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
