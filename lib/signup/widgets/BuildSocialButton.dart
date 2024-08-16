import 'package:flutter/material.dart';

class BuildSocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text; // Removed nullable type
  final VoidCallback onPressed;

  const BuildSocialButton({
    super.key,
    required this.icon,
    required this.color,
    this.text = '',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (text.isNotEmpty)
          Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * .02,
            ),
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
