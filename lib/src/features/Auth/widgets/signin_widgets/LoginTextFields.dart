import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/login_cubit/signin_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signin_widgets/LoginFormFields.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/AuthWelcomeText.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/account_navigation_prompt.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/pages/Signup.dart';

class LoginTextFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginTextFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> validateAndSignIn() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ToastUtil.showToast('Please fill in all required fields');
        return;
      }

      context.read<SigninCubit>().signInUser(
            email: email,
            password: password,
            context: context,
          );
    }

    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          ToastUtil.showToast('Login successful');
          Navigator.pushReplacementNamed(context, '/loginforanother');
        } else if (state is SigninFailure) {
          ToastUtil.showToast(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is SigninLoading) {
          return const Center(child: AppLoadingIndicator());
        }
        return Column(
          children: [
            const AuthWelcomeText(text: 'Login'),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            const Center(
              child: Text('Welcome back', style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            LoginFormFields(
              emailController: emailController,
              passwordController: passwordController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            const account_navigation_prompt(
              promptText: 'Don\'t have an account? ',
              actionText: 'Sign up',
              targetScreen: Signup(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            SignUpAndLoginButton(
              label: 'Sign in',
              icon: Icons.email,
              color: Colors.blue,
              onPressed: validateAndSignIn,
              isLogin: true,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
          ],
        );
      },
    );
  }
}
