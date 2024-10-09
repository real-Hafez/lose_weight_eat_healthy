import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/localization/styles/arabic_style.dart';

class OnboardingContentPage extends StatelessWidget {
  final String main_text;
  final String sub_text;

  const OnboardingContentPage({
    super.key,
    required this.main_text,
    required this.sub_text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .025,
          ),
          child: AutoSizeText(
            main_text,
            maxLines: 1,
            maxFontSize: 30,
            minFontSize: 18,
            style: ArabicStyle.arabicSemiBoldStyle(fontSize: 22.5).copyWith(
              color:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .065,
          ),
          child: Text(
            sub_text,
            style: ArabicStyle.arabicRegularStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
