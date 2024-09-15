import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class WaterIntakeWidget extends StatelessWidget {
  final double currentIntake;
  final double totalTarget;

  const WaterIntakeWidget({
    super.key,
    required this.currentIntake,
    required this.totalTarget,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = currentIntake / totalTarget;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: LiquidCustomProgressIndicator(
              value: percentage.clamp(0, 1),
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.grey.shade200, 
              direction: Axis.vertical, 
              shapePath:
                  _buildFullScreenPath(context),
            ),
          ),
          // Centered Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(percentage * 100).toStringAsFixed(0)}%", // Percentage text
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                Text(
                  "$currentIntake ml / $totalTarget ml", // Current and target water intake
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white, // Text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Path _buildFullScreenPath(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }
}
