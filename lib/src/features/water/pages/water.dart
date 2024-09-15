import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';

class water extends StatelessWidget {
  const water({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WaterIntakeWidget(
        currentIntake: 2200,
        totalTarget: 3000,
      ),
    );
  }
}
