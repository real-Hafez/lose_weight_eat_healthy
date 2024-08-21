import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signup_widgets/SignupIntroSection.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/AuthWelcomeText.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/CustomTextField.dart';

class SignupFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SignupIntroSection(),
        const AuthWelcomeText(text: 'Create a new account'),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: firstNameController,
                hintText: 'Ahmed',
                label: 'First name',
                isRequired: true,
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * .02),
            Expanded(
              child: CustomTextField(
                controller: lastNameController,
                hintText: 'Hafez',
                label: 'Last name',
                isRequired: false, // Not required
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
          ],
        ),
        CustomTextField(
          controller: usernameController,
          hintText: 'ahmed140',
          label: 'Username',
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.name,
        ),
        CustomTextField(
          controller: emailController,
          hintText: 'email@example.com',
          label: 'Email',
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomTextField(
          controller: passwordController,
          hintText: 'Ahmed@9510',
          label: 'Password',
          isRequired: true,
          isPassword: true,
          // keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }
}
