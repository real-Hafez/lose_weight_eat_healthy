import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding/screen/onboarding.dart';

class Splash_Screen extends StatelessWidget {
  const Splash_Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/giphy_logo_google_GIF.webp',
      gifWidth: 200,
      gifHeight: 474,
      nextScreen: const OnBoarding(),
      duration: const Duration(milliseconds: 300),
    );
  }
}
