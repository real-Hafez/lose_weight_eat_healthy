import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Settings/widget/Water_unit_preferences.dart';

class settings_screen extends StatelessWidget {
  const settings_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Water_unit_preferences(),
        ),
      ],
    );
  }
}
