import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Calorie_Progress_Indicator extends StatelessWidget {
  const Calorie_Progress_Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 13.0,
      percent: 1335 / 1800,
      center: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            "1335 Kcal",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "/1800 Kcal",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
      progressColor: Colors.orange,
      backgroundColor: Colors.white12,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
