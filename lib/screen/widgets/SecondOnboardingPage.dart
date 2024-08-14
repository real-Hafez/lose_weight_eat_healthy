import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/screen/widgets/on_Boarding_text_style.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTextStyle(
      main_text: 'Quick Recipes, Healthy Results',
      sub_text:
          'Discover the quickest way to nutritious meals that help you stay fit and healthy.',
    );
  }
}
