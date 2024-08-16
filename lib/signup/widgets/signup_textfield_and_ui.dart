import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/SignIn/SignInscreen.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignupIntroSection.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/create_new_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/have_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/text_field_for_sign_up_and_login.dart';

class signup_textfield_and_ui extends StatelessWidget {
  const signup_textfield_and_ui({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SignupIntroSection(),
        const create_account_Text(),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                size: Size(MediaQuery.of(context).size.height * .3, 50),
                hintText: 'ahmed',
                label: 'first name',
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .02,
            ),
            Expanded(
              child: CustomTextField(
                size: Size(MediaQuery.of(context).size.height * .3, 50),
                hintText: 'hafez',
                label: 'last name',
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
          ],
        ),
        const CustomTextField(
          hintText: 'ahmed140',
          label: 'user name',
          isPassword: false,
          keyboardType: TextInputType.name,
        ),
        const CustomTextField(
          hintText: 'email@example.com',
          label: 'Email',
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        const CustomTextField(
          hintText: 'Ahmed@9510',
          label: 'password',
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        const HaveAccount(
          promptText: 'Do you already have an account? ',
          actionText: 'Log in',
          targetScreen: Signinscreen(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        SignUpAndLoginButton(
          label: 'Sign up ',
          icon: Icons.email,
          color: Colors.blue,
          onPressed: () {},
        ),
      ],
    );
  }
}
