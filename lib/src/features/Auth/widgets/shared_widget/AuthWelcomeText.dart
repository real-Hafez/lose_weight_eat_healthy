import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/localization/styles/arabic_style.dart';

class AuthWelcomeText extends StatelessWidget {
  const AuthWelcomeText({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AutoSizeText(
        text,
        maxLines: 1,
        maxFontSize: 40,
        minFontSize: 22,
        style: ArabicStyle.arabicSemiBoldStyle(
          fontSize: MediaQuery.of(context).size.height * .04,
        ).copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}
