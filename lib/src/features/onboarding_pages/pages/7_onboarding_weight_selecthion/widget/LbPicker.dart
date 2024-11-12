import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';

class LbPicker extends StatefulWidget {
  final double weightLb;
  final ValueChanged<double> onWeightChanged;

  const LbPicker({
    super.key,
    required this.weightLb,
    required this.onWeightChanged,
  });

  @override
  _LbPickerState createState() => _LbPickerState();
}

class _LbPickerState extends State<LbPicker> {
  late int weightValue;

  @override
  void initState() {
    super.initState();
    // Initialize weightValue rounded and clamped within min/max bounds
    weightValue = _validateWeightValue((widget.weightLb * 10).round());
  }

  @override
  void didUpdateWidget(covariant LbPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightLb != widget.weightLb) {
      // Update weightValue if the incoming weightLb prop changes
      setState(() {
        weightValue = _validateWeightValue((widget.weightLb * 10).round());
      });
    }
  }

  // Helper function to validate weightValue
  int _validateWeightValue(int value) {
    if (value > 3640) {
      return 3640; // Max value
    } else if (value < 992) {
      return 992; // Min value
    } else if (value <= 0) {
      return 155; // Default value in case of an invalid value
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final String currentLocale = context.read<LocaleCubit>().state.languageCode;

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
        borderRadius: BorderRadius.circular(10),
      ),
      child: NumberPicker(
        axis: Axis.horizontal,
        haptics: true,
        value: weightValue,
        minValue: 992,
        maxValue: 3640,
        step: 1,
        onChanged: (value) {
          setState(() {
            weightValue = value;
          });
          widget.onWeightChanged(value / 10.0);
        },
        textStyle: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * .018,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
        selectedTextStyle: TextStyle(
          fontSize: MediaQuery.sizeOf(context).height * .035,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: const [
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
