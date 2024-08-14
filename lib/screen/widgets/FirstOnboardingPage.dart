import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/screen/widgets/on_Boarding_text_style.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTextStyle(
      main_text: 'Find the Best Cardio Workout for You',
      sub_text:
          'the train is customized for u bassed on u weight to reach u target to be better of yourslf',
    );
  }
}
