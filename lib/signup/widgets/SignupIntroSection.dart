import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SignupIntroSection extends StatelessWidget {
  const SignupIntroSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            'Discover our app, it\'s',
            maxLines: 1,
            maxFontSize: 30,
            minFontSize: 18,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * .04,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .03,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * .03,

              // fontFamily: 'Horizon',
              color: Colors.green,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText('PERSONALIZED TRAINING',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('PERSONALIZED TRAINING',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('HEALTHY RECIPE SUGGESTIONS',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('CUSTOM WORKOUT PLANS',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('PROGRESS TRACKING',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('DAILY MOTIVATION',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('MEAL PLANNING',
                    duration: const Duration(milliseconds: 1950)),
                RotateAnimatedText('EXPERT TRAINING TIPS',
                    duration: const Duration(milliseconds: 1950)),
              ],
              pause: const Duration(seconds: 0),
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
          ),
        ),
      ],
    );
  }
}
