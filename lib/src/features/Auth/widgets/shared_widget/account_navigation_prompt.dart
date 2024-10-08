import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/localization/styles/arabic_style.dart';

class account_navigation_prompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final Widget targetScreen;

  const account_navigation_prompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.targetScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          text: promptText,
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: actionText,
              style: ArabicStyle.arabicLightStyle().copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
