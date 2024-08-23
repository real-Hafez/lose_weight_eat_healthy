import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart'; // For localization
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/login_cubit/signin_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/cubit/signup_cubit/signup_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/widgets/shared_widget/BuildSocialButton.dart';

class SignUpAndLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  // Flag to determine if it's for login or signup
  final bool isLogin;

  // Callback function to be called when the button is pressed.
  final VoidCallback onPressed;

  const SignUpAndLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLogin = false,
  });

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (isLogin) {
      final cubit = context.read<SigninCubit>();
      await cubit.signInWithGoogle(context: context);
    } else {
      final cubit = context.read<SignupCubit>();
      await cubit.signInWithGoogle(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: Icon(icon, color: Colors.white),
            label: Text(label, style: const TextStyle(color: Colors.white)),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          color: Colors.grey.shade400,
          thickness: 2.0,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        AutoSizeText(
          isLogin ? S.of(context).orLoginWith : S.of(context).orSignupWith,
          maxLines: 1,
          maxFontSize: 45,
          minFontSize: 30,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .04,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .003),
        SizedBox(width: MediaQuery.of(context).size.width * .05),
        BuildSocialButton(
          onPressed: () => _signInWithGoogle(context),
          image: 'assets/Google_logo.png',
        ),
      ],
    );
  }
}
