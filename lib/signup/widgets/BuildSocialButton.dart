import 'package:flutter/material.dart';

class BuildSocialButton extends StatelessWidget {
  final String Image;
  final String text; // Removed nullable type
  final VoidCallback onPressed;

  const BuildSocialButton({
    super.key,
    required this.Image,
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
            backgroundImage: AssetImage(Image),
            radius: 25,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
