import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/pages/FirstOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/pages/SecondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/pages/ThirdOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/pages/Signup.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/utils/onboarding_images.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        centerBackground: true,
        speed: 1,
        headerBackgroundColor: Colors.white,
        finishButtonText: S.of(context).new_account,
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        skipTextButton: Text(
          S.of(context).skipbutton,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        background: [
          OnboardingImages.freeIconsSvg(context),
          OnboardingImages.appleFreeIconsSvg(context),
          OnboardingImages.freeFreeIconsSvg(context),
        ],
        totalPage: 3,
        pageBodies: const [
          FirstOnboardingPage(),
          SecondOnboardingPage(),
          ThirdOnboardingPage(),
        ],
        controllerColor: Colors.orange,
        onFinish: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Signup(),
            ),
          );
        },
      ),
    );
  }
}
