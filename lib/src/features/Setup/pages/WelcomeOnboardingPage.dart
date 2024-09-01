import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';

class WelcomeOnboardingPage extends StatelessWidget {
  final VoidCallback onAnimationFinished;

  const WelcomeOnboardingPage({
    super.key,
    required this.onAnimationFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: AnimatedTextWidget(onFinished: onAnimationFinished, text: 'df'
          // 'Welcome to your journey toward a healthier and happier you! Our app is here to support you every step of the way with a range of free features designed to help you reach your goals effortlessly.',
          ),
    );
  }
}
