import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
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
        AuthWelcomeText(
          text: S.of(context).newAccount,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: firstNameController,
                hintText: S.of(context).firstNameHint,
                label: S.of(context).firstNameLabel,
                isRequired: true,
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * .02),
            Expanded(
              child: CustomTextField(
                controller: lastNameController,
                hintText: S.of(context).lastNameHint,
                label: S.of(context).lastNameLabel,
                isRequired: false, // Not required
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
          ],
        ),
        CustomTextField(
          controller: usernameController,
          hintText: S.of(context).usernameHint,
          label: S.of(context).usernameLabel,
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.name,
        ),
        CustomTextField(
          controller: emailController,
          hintText: S.of(context).emailHint,
          label: S.of(context).emailLabel,
          isRequired: true,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomTextField(
          controller: passwordController,
          hintText: S.of(context).passwordHint,
          label: S.of(context).passwordLabel,
          isRequired: true,
          isPassword: true,
          // keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }
}
