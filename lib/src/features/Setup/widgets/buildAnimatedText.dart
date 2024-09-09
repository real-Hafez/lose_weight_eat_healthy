import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextWidget extends StatelessWidget {
  final VoidCallback onFinished;
  final String text;

  const AnimatedTextWidget({
    super.key,
    required this.onFinished,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textAlign: TextAlign.center,
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
    );
  }
}
