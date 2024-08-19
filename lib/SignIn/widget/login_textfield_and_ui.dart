import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/text_field_for_sign_up_and_login.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'email@example.com',
          label: 'Email',
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        CustomTextField(
          controller: passwordController,
          hintText: '********',
          label: 'Password',
          isRequired: true,
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }
}
