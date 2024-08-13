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
        background: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * .01),
            child: const VideoWidget(
              videoPath: 'assets/on-boarding-assets/895109962323Workout.mp4',
              // height: MediaQuery.of(context).size.height * .2,
            ),
          ),
          const VideoWidget(
            videoPath: 'assets/on-boarding-assets/895109962323Workout.mp4',
            // height: 200,
          ),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                ),
                const onboarding_First_page(),
              ],
            ),
          ),
          const onboarding_Second_page(),
        ],
      ),
    );
  }
}
