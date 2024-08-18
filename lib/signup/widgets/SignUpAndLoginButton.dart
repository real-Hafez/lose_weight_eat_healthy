import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/BuildSocialButton.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/GoogleSignuP.dart';

class SignUpAndLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SignUpAndLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
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
          // text: 'Google',
          Image: 'assets/Google_logo.png',
          onPressed: () async {
            Authentication.signInWithGoogle(context: context);
          },
        ),
      ],
    );
  }
}
