import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lose_weight_eat_healthy/screen/widgets/FirstOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/screen/widgets/SecondOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/screen/widgets/ThirdOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/signup/Signup.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardingSlider(
          centerBackground: true,
          speed: 1,
          headerBackgroundColor: Colors.white,
          finishButtonText: 'Sign Up',
          finishButtonStyle: FinishButtonStyle(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          skipTextButton: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          background: [
            SvgPicture.asset(
              'assets/on-boarding-assets/freeicons.io.svg',
              height: MediaQuery.of(context).size.height * .29,
            ),
            SvgPicture.asset('assets/on-boarding-assets/apple-freeicons.io.svg',
                height: MediaQuery.of(context).size.height * .29),
            SvgPicture.asset(
              'assets/on-boarding-assets/free-freeicons.io.svg',
              height: MediaQuery.of(context).size.height * .35,
            ),
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
          }),
    );
  }
}
