import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/widgets/on_Boarding_text_style.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextStyle(
      main_text: S.of(context).main_text_secondOnboardingPage,
      sub_text: S.of(context).sub_text_secondOnboardingPage,
    );
  }
}
