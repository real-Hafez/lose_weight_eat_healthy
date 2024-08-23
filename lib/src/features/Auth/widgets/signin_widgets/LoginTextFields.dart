import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/login_cubit/signin_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signin_widgets/LoginFormFields.dart';
import 'package:lose_weight_eat_healthy/src/localization/styles/arabic_style.dart';
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
        ToastUtil.showToast(S.of(context).forgetfield);
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
          ToastUtil.showToast(S.of(context).Loginsuccessful);
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
            AuthWelcomeText(
              text: S.of(context).Login,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Center(
              child: Text(
                S().welcomeBack,
                style: ArabicStyle.arabicRegularStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            LoginFormFields(
              emailController: emailController,
              passwordController: passwordController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            account_navigation_prompt(
              promptText: S.of(context).dontHaveAccount,
              actionText: S.of(context).signUp,
              targetScreen: const Signup(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            SignUpAndLoginButton(
              label: S.of(context).signIn,
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
