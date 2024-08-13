import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lose_weight_eat_healthy/screen/VideoWidget.dart';
import 'package:lose_weight_eat_healthy/screen/onboarding_First_page.dart';
import 'package:lose_weight_eat_healthy/screen/onboarding_Second_page.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Colors.black,
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        finishButtonText: 'Register',
        finishButtonStyle: const FinishButtonStyle(),
        skipTextButton: const Text('Skip'),
        trailing: const Text('Login'),
        background: const [
          VideoWidget(
            videoPath: 'assets/on-boarding-assets/battle-rope.mp4',
            height: 200,
          ),
          VideoWidget(
            videoPath: 'assets/on-boarding-assets/Workout_Plans.mp4',
            height: 200,
          ),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                VideoWidget(
                  videoPath: 'assets/on-boarding-assets/battle-rope.mp4',
                  height: 300,
                ),
                // SizedBox(height: 10),
                onboarding_First_page(),
              ],
            ),
          ),
          const onboarding_Second_page(),
        ],
      ),
    );
  }
}
