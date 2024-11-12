import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
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
    final int weightValue = (weightKg * 10).toInt().clamp(450, 1650);

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
        minValue: 450, // 45.0 kg * 10
        maxValue: 1650, // 165.0 kg * 10
        step: 1,
        onChanged: (value) => onWeightChanged(value / 10.0),
        textStyle: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * .020,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
        selectedTextStyle: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * .035,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: const [
            Shadow(
              blurRadius: 6.0,
              color: Colors.red,
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
          return isArabic
              ? NumberConversionHelper.convertToArabicNumbers(
                  number.toStringAsFixed(1))
              : number.toStringAsFixed(1);
        },
      ),
    );
  }
}
