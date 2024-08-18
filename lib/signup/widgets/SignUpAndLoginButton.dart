import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/signup/cubit/cubit/signup_cubit.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/BuildSocialButton.dart';

class SignUpAndLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLogin;
  final VoidCallback onPressed;

  const SignUpAndLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLogin = false,
  });

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
        Text(
          'Or sign up with',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .04,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .003),
        SizedBox(width: MediaQuery.of(context).size.width * .05),
        BuildSocialButton(
          onPressed: () async {
            // Use the isLogin flag to determine the action
            final cubit = context.read<SignupCubit>();
            if (isLogin) {
              await cubit.signInWithGoogle(context: context);
            } else {
              await cubit.signInWithGoogle(context: context);
            }
          },
          Image: 'assets/Google_logo.png',
        ),
      ],
    );
  }
}
