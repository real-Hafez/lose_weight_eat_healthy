import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class LbPicker extends StatelessWidget {
  final double weightLb;
  final ValueChanged<double> onWeightChanged;

  const LbPicker({
    super.key,
    required this.weightLb,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[100]!, // Soft light gray
            Colors.blue[50]!, // Very light blue
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: NumberPicker(
        axis: Axis.horizontal,
        haptics: true,
        value: (weightLb * 10).toInt(), // Convert to integer for NumberPicker
        minValue: 660, // 66.0 lb * 10   
        maxValue: 3640, // 165.0 lb * 10 
        step: 1, // Step by 0.1 lb
        onChanged: (value) =>
            onWeightChanged(value / 10.0), // Convert back to double
        textStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey[500], // Slightly darker gray for unselected items
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent, // Blue accent for selected item
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black26,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        itemHeight:
            80, // Increase the height of each item for better visibility
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blueAccent, width: 2),
            bottom: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        textMapper: (numberText) {
          // Convert the integer value to a string with one decimal place
          return (int.parse(numberText) / 10.0).toStringAsFixed(1);
        },
      ),
    );
  }
}
