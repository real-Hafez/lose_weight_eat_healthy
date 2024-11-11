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
          fontSize: MediaQuery.sizeOf(context).height * .018,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
        selectedTextStyle: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * .035,
          fontWeight: FontWeight.w900,
          color: Colors.white,
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
            top: BorderSide(color: Color(0xFFFFEB3B), width: 2),
            bottom: BorderSide(color: Color(0xFF9C27B0), width: 2),
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
