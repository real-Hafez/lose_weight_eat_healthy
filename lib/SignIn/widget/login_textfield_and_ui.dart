import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/Signup.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/BuildSocialButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/create_new_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/have_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/text_field_for_sign_up_and_login.dart';

class LoginTextfieldAndUi extends StatelessWidget {
  const LoginTextfieldAndUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .06,
        ),
        const Center(
          child: create_account_Text(
            text: 'Welcome back',
          ),
        ),
        const create_account_Text(
          text: 'Login',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        const CustomTextField(
          label: 'user name or email',
          hintText: 'your username or email',
          isPassword: false,
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        const CustomTextField(
          label: 'Password',
          hintText: '***********',
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        const HaveAccount(
          promptText: 'You don\'t Have account? ',
          actionText: 'Sign up',
          targetScreen: Signup(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        Divider(
          color: Colors.grey.shade400,
          thickness: 2.0,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Text(
          'Or sign in with',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .04,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .003),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildSocialButton(
              // text: 'Facebook',
              icon: Icons.facebook,
              color: Colors.blueAccent,
              onPressed: () {
                // Handle Facebook sign-in
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * .05),
            BuildSocialButton(
              // text: 'Google',
              icon: Icons.email,
              color: Colors.redAccent,
              onPressed: () {
                // Handle Google sign-in
              },
            ),
          ],
        ),
      ],
    );
  }
}
