import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/screen/on_boarding_widget.dart';

class onboarding_First_page extends StatelessWidget {
  const onboarding_First_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        const on_boarding_widget(
          icon: Icons.directions_run,
          sub_title:
              "Access a range of cardio workouts for all fitness levels, anytime, anywhere.",
          main_title: 'Work Out Anywhere, Anytime',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        const on_boarding_widget(
          icon: Icons.headset,
          sub_title:
              "Stay focused with simple audio guidance during your workouts.",
          main_title: 'Guided Audio Instructions',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        const on_boarding_widget(
          icon: Icons.alarm,
          sub_title:
              "Set custom workout reminders to stay consistent and reach your fitness goals.",
          main_title: 'Workout Reminders',
        ),
      ],
    );
  }
}
