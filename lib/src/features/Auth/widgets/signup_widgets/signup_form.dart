import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/pages/Login.dart';
import 'package:lose_weight_eat_healthy/UserService.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';
import 'package:lose_weight_eat_healthy/home.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/signup_cubit/signup_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/signup_widgets/SignupFormFields.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/SignUpAndLoginButton.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/account_navigation_prompt.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';

class signup_form extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const signup_form({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();

    Future<void> validateAndSubmit() async {
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

      // Check if username is available
      final isUsernameTaken = await userService.isUsernameTaken(username);

      if (isUsernameTaken) {
        ToastUtil.showToast('Username is already taken');
        return;
      }

      // Proceed with sign-up
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
          ToastUtil.showToast('Signup successful');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
          }));
        } else if (state is SignupFailure) {
          ToastUtil.showToast(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is SignupLoading) {
          return const Center(child: AppLoadingIndicator());
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
            const account_navigation_prompt(
              promptText: 'Do you already have an account? ',
              actionText: 'Log in',
              targetScreen: Login(),
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
