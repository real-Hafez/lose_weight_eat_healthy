import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/widgets/on_Boarding_text_style.dart';

class ThirdOnboardingPage extends StatelessWidget {
  const ThirdOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTextStyle(
      main_text: 'Absolutely Free for Your Health',
      sub_text:
          'It’s all free! We want you to get fit and healthy, so enjoy our content with no cost.',
    );
  }
}
