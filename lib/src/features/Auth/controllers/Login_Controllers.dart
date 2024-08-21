import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signin_widgets/LoginTextFields.dart';

class LoginControllers extends StatelessWidget {
  const LoginControllers({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiating controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return LoginTextFields(
      emailController: emailController,
      passwordController: passwordController,
    );
  }
}
