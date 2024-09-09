import 'package:flutter/material.dart';

class WeightLosstarget extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final String weightUnit;

  const WeightLosstarget({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    final weightDifference = currentWeight - targetWeight;
    final weightLost = weightDifference.toStringAsFixed(1);
    final isGain = weightDifference < 0;
    final displayWeight = isGain ? 'gain' : 'lose';
    final timeEstimate = _estimateTime(weightDifference);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You are going to $displayWeight $weightLost $weightUnit',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isGain
                    ? Colors.red
                    : Colors.green, // Red for gain, green for loss
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'This will take approximately $timeEstimate',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isGain ? Colors.red : Colors.green,
              ),
        ),
      ],
    );
  }

  String _estimateTime(double weightDifference) {
    // Calculate time based on a range of 0.7 to 1.2 kg per week
    const double minRatePerWeek = 0.7;
    const double maxRatePerWeek = 1.2;

    final weeksMin = weightDifference / maxRatePerWeek;
    final weeksMax = weightDifference / minRatePerWeek;

    // Convert weeks to days
    final minDays = (weeksMin * 7).isNaN || (weeksMin * 7).isInfinite
        ? 0
        : (weeksMin * 7).toStringAsFixed(0);
    final maxDays = (weeksMax * 7).isNaN || (weeksMax * 7).isInfinite
        ? 0
        : (weeksMax * 7).toStringAsFixed(0);

    return weightDifference > 0
        ? '$minDays to $maxDays days'
        : '0 days'; // Adjust for weight gain or insufficient weight loss
  }
}
