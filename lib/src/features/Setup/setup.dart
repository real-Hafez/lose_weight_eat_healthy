import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/OnboardingPage.dart';

class setup extends StatelessWidget {
  const setup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: OnboardingPage(),
    );
  }
}
