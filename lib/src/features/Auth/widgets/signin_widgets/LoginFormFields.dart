import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/CustomTextField.dart';

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
          label: S.of(context).emailLabel,
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        CustomTextField(
          controller: passwordController,
          hintText: '********',
          label: S.of(context).passwordLabel,
          isRequired: true,
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }
}
