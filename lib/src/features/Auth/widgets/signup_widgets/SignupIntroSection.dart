import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class SignupIntroSection extends StatelessWidget {
  const SignupIntroSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AutoSizeText(
          S.of(context).discoverApp,
          maxLines: 1,
          maxFontSize: 30,
          minFontSize: 18,
          style: theme.headlineMedium?.copyWith(
            // Use headlineMedium from theme
            fontSize: MediaQuery.of(context).size.height * .04,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .1,
          child: DefaultTextStyle(
            style: theme.bodyLarge!.copyWith(
              // Use bodyLarge from theme
              fontSize: MediaQuery.of(context).size.height * .03,
              color: theme.bodyLarge?.color ??
                  Colors.green, // Use the theme's color
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText(S.of(context).personalizedTraining,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).dailyMotivation,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).healthyRecipeSuggestions,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).customWorkoutPlans,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).progressTracking,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).dailyMotivation,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).mealPlanning,
                    duration: const Duration(milliseconds: 2200)),
                RotateAnimatedText(S.of(context).expertTrainingTips,
                    duration: const Duration(milliseconds: 2200)),
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
