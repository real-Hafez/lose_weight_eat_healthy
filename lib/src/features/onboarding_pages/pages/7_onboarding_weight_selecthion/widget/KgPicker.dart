import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';

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

    // Check if Arabic is selected to determine number formatting
    final bool isArabic =
        context.read<LocaleCubit>().state.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF6F61),
            Color(0xFF9C27B0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withOpacity(0.3),
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
        onChanged: (value) => onWeightChanged(value / 10.0),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 6.0,
              color: Color(0xFFFFEB3B),
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        itemHeight: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFFFEB3B), width: 2),
            bottom: BorderSide(color: Color(0xFF9C27B0), width: 2),
          ),
        ),
        textMapper: (numberText) {
          double number = int.parse(numberText) / 10.0;
          // Convert to Arabic numerals if Arabic is selected
          return isArabic
              ? _convertToArabicNumbers(number.toStringAsFixed(1))
              : number.toStringAsFixed(1);
        },
      ),
    );
  }

  // Helper function to convert numbers to Arabic numerals if user chooee arabicl ang
  String _convertToArabicNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => arabicNumbers[int.parse(match.group(0)!)],
    );
  }
}
