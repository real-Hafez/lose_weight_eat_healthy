import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignupIntroSection.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignupIntroSection(),
      ),
    );
  }
}
