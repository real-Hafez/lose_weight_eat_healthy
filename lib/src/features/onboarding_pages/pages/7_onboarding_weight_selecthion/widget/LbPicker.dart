import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';

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
    // Access the current locale to check if Arabic is selected
    final String currentLocale = context.read<LocaleCubit>().state.languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.yellow,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: NumberPicker(
        axis: Axis.horizontal,
        haptics: true,
        value: (weightLb * 10).toInt(),
        minValue: 992, // 66.0 lb * 10
        maxValue: 3640, // 165.0 lb * 10
        step: 1,
        onChanged: (value) => onWeightChanged(value / 10.0),
        textStyle: TextStyle(
          fontSize: 22,
          color: Colors.yellow[500],
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black26,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        itemHeight: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blueAccent, width: 2),
            bottom: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        textMapper: (numberText) {
          // Convert to one decimal place and change numbers to Arabic if needed
          String displayedText =
              (int.parse(numberText) / 10.0).toStringAsFixed(1);
          return currentLocale == 'ar'
              ? NumberConversionHelper.convertToArabicNumbers(displayedText)
              : displayedText;
        },
      ),
    );
  }
}
