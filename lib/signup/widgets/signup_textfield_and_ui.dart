import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/SignIn/SignInscreen.dart';
import 'package:lose_weight_eat_healthy/consent.dart';
import 'package:lose_weight_eat_healthy/home.dart';
import 'package:lose_weight_eat_healthy/signup/cubit/cubit/signup_cubit.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignupFormFields.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/have_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/loading.dart';

class SignupTextFields extends StatelessWidget {
  const SignupTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void validateAndSubmit() {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (firstName.isEmpty ||
          username.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        ToastUtil.showToast('Please fill in all required fields');

        return;
      }

      context.read<SignupCubit>().signupUser(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            password: password,
            context: context,
          );
    }

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          print('Signup successful');
          ToastUtil.showToast('Signup successful');
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          ));
        } else if (state is SignupFailure) {
          print('Signup failed');
          ToastUtil.showToast(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is SignupLoading) {
          return const Center(child: LoadingWidget());
        }
        return Column(
          children: [
            SignupFormFields(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              usernameController: usernameController,
              emailController: emailController,
              passwordController: passwordController,
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
              onPressed: validateAndSubmit,
            ),
          ],
        );
      },
    );
  }
}
