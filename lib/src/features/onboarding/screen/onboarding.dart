import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/Routes/app_routes.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/pages/OnboardingContentPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/utils/onboarding_images.dart';
import 'package:lose_weight_eat_healthy/src/localization/styles/arabic_style.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      centerBackground: true,
      speed: 1,
      pageBackgroundColor: Colors.teal,
      headerBackgroundColor: Colors.transparent,
      finishButtonText: S.of(context).newAccount,
      finishButtonTextStyle: ArabicStyle.arabicMediumStyle(fontSize: 20)
          .copyWith(color: Colors.black),
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      skipTextButton: Text(S.of(context).skipButton,
          style: ArabicStyle.arabicMediumStyle(
            fontSize: 20,
          ).copyWith(
            color: Colors.black,
          )),
      background: [
        OnboardingImages.freeIconsSvg(context),
        OnboardingImages.appleFreeIconsSvg(context),
        OnboardingImages.freeFreeIconsSvg(context),
      ],
      totalPage: 3,
      pageBodies: [
        OnboardingContentPage(
          main_text: S.of(context).mainTextFirstOnboardingPage,
          sub_text: S.of(context).subTextFirstOnboardingPage,
        ),
        OnboardingContentPage(
          main_text: S.of(context).mainTextSecondOnboardingPage,
          sub_text: S.of(context).subTextSecondOnboardingPage,
        ),
        OnboardingContentPage(
          main_text: S.of(context).mainTextThirdOnboardingPage,
          sub_text: S.of(context).subTextThirdOnboardingPage,
        ),
      ],
      controllerColor: Colors.orange,
      onFinish: () {
        Navigator.pushReplacementNamed(context, AppRoutes.signup);
      },
    );
  }
}
