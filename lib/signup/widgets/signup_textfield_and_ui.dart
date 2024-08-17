import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/SignIn/SignInscreen.dart';
import 'package:lose_weight_eat_healthy/signup/cubit/cubit/signup_cubit.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignupIntroSection.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/create_new_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/have_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/text_field_for_sign_up_and_login.dart';

class signup_textfields extends StatelessWidget {
  const signup_textfields({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      children: [
        const SignupIntroSection(),
        const create_account_Text(text: 'Create a new account'),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: firstNameController,
                hintText: 'ahmed',
                label: 'First name',
                isPassword: false,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * .02),
            Expanded(
              child: CustomTextField(
                controller: lastNameController,
                hintText: 'hafez',
                label: 'Last name',
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
          isPassword: false,
          keyboardType: TextInputType.name,
        ),
        CustomTextField(
          controller: emailController,
          hintText: 'email@example.com',
          label: 'Email',
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomTextField(
          controller: passwordController,
          hintText: 'Ahmed@9510',
          label: 'Password',
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        const HaveAccount(
          promptText: 'Do you already have an account? ',
          actionText: 'Log in',
          targetScreen: Signinscreen(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        SignUpAndLoginButton(
          label: 'Sign up',
          icon: Icons.email,
          color: Colors.blue,
          onPressed: () {
            context.read<SignupCubit>().signupUser(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
          },
        ),
      ],
    );
  }
}
