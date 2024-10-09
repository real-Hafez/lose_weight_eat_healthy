import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signup_widgets/signup_form.dart';

class SignupControllers extends StatelessWidget {
  const SignupControllers({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiating controllers
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return signup_form(
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      usernameController: usernameController,
      emailController: emailController,
      passwordController: passwordController,
    );
  }
}
