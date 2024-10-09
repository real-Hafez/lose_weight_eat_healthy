// lib/features/onboarding/presentation/widgets/animated_text_content.dart

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextContent extends StatelessWidget {
  final VoidCallback onFinished;

  const AnimatedTextContent({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Welcome to your journey toward a healthier and happier you! Our app is here to support you every step of the way with a range of free features designed to help you reach your goals effortlessly.',
              speed: const Duration(milliseconds: 70),
              textStyle: const TextStyle(
                fontSize: 30,
                fontFamily: 'Indie_Flower',
              ),
            ),
            TypewriterAnimatedText(
              'hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi hi',
              speed: const Duration(milliseconds: 70),
              textStyle: const TextStyle(
                fontSize: 30,
                fontFamily: 'Indie_Flower',
              ),
            ),
          ],
          onFinished: onFinished,
          isRepeatingAnimation: false,
          repeatForever: false,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
