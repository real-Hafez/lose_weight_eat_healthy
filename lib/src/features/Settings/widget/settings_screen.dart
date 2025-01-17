import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Settings/widget/Water_unit_preferences.dart';

class settings_screen extends StatelessWidget {
  const settings_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Mahmood hafez',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.green,
              maxRadius: 60,
            ),
          ],
        ),

        // Expanded(
        // child: Water_unit_preferences(),
        // ),
      ],
    );
  }
}
