import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/controllers/signup_controllers.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: SignupControllers(),
          ),
        ),
      ),
    );
  }
}
