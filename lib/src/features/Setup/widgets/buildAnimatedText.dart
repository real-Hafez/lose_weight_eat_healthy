import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextWidget extends StatelessWidget {
  final VoidCallback onFinished;
  final String text;

  const AnimatedTextWidget({
    Key? key,
    required this.onFinished,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          speed: const Duration(milliseconds: 70),
          textStyle: const TextStyle(
            fontSize: 30,
            fontFamily: 'Indie_Flower',
          ),
        ),
      ],
      onFinished: onFinished,  // Triggers when the animation completes
      isRepeatingAnimation: false,
      repeatForever: false,
    );
  }
}
