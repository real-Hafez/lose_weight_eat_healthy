// lib/src/shared/BmiHelper.dart

import 'package:flutter/material.dart';

class BmiHelper {
  static Map<String, dynamic> getBmiDetails(double bmiValue) {
    String bmiStatus = "Normal weight";
    String recommendation =
        "Keep up the good work and maintain a healthy lifestyle!";
    Color statusColor = Colors.green;

    if (bmiValue < 16) {
      bmiStatus = "Severe Thinness";
      recommendation =
          "A healthier you is within reach! Consider consulting a healthcare professional, and explore our app's nutrition plans to support your journey.";
      statusColor = Colors.purple;
    } else if (bmiValue >= 16 && bmiValue < 17) {
      bmiStatus = "Moderate Thinness";
      recommendation =
          "A balanced diet can make a world of difference. Our nutrition plans are here to help you reach your ideal weight.";
      statusColor = Colors.orange;
    } else if (bmiValue >= 17 && bmiValue < 18.5) {
      bmiStatus = "Mild Thinness";
      recommendation =
          "Small changes can lead to great results! Try our healthy meal options to get closer to your wellness goals.";
      statusColor = Colors.yellow;
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      bmiStatus = "Normal";
      recommendation =
          "You’re on the right track! Keep up the great habits and explore new ways to maintain a balanced lifestyle.";
      statusColor = Colors.green;
    } else if (bmiValue >= 25 && bmiValue < 30) {
      bmiStatus = "Overweight";
      recommendation =
          "You're closer to a healthier weight than you think! A nutritious diet and regular exercise can make a big difference. Let’s start together!";
      statusColor = Colors.orangeAccent;
    } else if (bmiValue >= 30 && bmiValue < 35) {
      bmiStatus = "Obese Class I";
      recommendation =
          "With dedication and the right choices, a healthier weight is achievable. Explore our meal plans and workouts tailored to support your journey.";
      statusColor = Colors.redAccent;
    } else if (bmiValue >= 35 && bmiValue < 40) {
      bmiStatus = "Obese Class II";
      recommendation =
          "Your health is a priority. Our app can guide you with personalized nutrition and activity plans to get closer to your goal.";
      statusColor = Colors.red;
    } else if (bmiValue >= 40) {
      bmiStatus = "Obese Class III";
      recommendation =
          "Together, we can make a difference in your health. Consult a healthcare provider and start with our nutrition and wellness options for a fresh start.";
      statusColor = Colors.deepOrange;
    }

    return {
      'bmiStatus': bmiStatus,
      'recommendation': recommendation,
      'statusColor': statusColor,
    };
  }
}
