import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/SignIn/cubit/cubit/signin_cubit.dart';
import 'package:lose_weight_eat_healthy/SignIn/widget/login_textfield_and_ui.dart';
import 'package:lose_weight_eat_healthy/consent.dart';
import 'package:lose_weight_eat_healthy/signup/Signup.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/have_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/loading.dart';

class LoginTextFieldAndUi extends StatelessWidget {
  const LoginTextFieldAndUi({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
          return const Center(child: LoadingWidget());
        }
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .06),
            const Center(
              child: Text('Welcome back', style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            LoginFormFields(
              emailController: emailController,
              passwordController: passwordController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            const HaveAccount(
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
