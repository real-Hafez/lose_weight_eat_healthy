import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/widgets/on_Boarding_text_style.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTextStyle(
        main_text: 'Find Your Perfect Cardio Routine',
        sub_text:
            "Browse videos that match your fitness level and help you reach your cardio goals.");
  }
}
