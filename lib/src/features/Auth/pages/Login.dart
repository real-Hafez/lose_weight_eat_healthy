import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/controllers/Login_Controllers.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: LoginControllers(),
          ),
        ),
      ),
    );
  }
}
