import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class KgPicker extends StatelessWidget {
  final double weightKg;
  final ValueChanged<double> onWeightChanged;

  const KgPicker({
    super.key,
    required this.weightKg,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int weightValue = (weightKg * 10).toInt().clamp(300, 1650);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF6F61), // Vibrant Coral
            Color(0xFF9C27B0), // Soft Purple
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF9C27B0).withOpacity(0.3), // Soft purple shadow
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: NumberPicker(
        axis: Axis.horizontal,
        haptics: true,
        value: weightValue,
        minValue: 450,
        maxValue: 1650,
        step: 1,
        onChanged: (value) => onWeightChanged(
          value / 10.0,
        ),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,

          color: Colors.white, // White text for clarity
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: Colors.white, // White text for the selected item
          shadows: [
            Shadow(
              blurRadius: 6.0,
              color: Color(0xFFFFEB3B), // Bright yellow glow for selected text
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        itemHeight: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Color(0xFFFFEB3B),
                width: 2), // Bright yellow for top border
            bottom: BorderSide(
                color: Color(0xFF9C27B0),
                width: 2), // Soft purple for bottom border
          ),
        ),
        textMapper: (numberText) {
          return (int.parse(numberText) / 10.0).toStringAsFixed(1);
        },
      ),
    );
  }
}
