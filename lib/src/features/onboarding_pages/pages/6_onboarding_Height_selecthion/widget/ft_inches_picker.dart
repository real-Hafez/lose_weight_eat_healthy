import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:numberpicker/numberpicker.dart';

class FtInchesPicker extends StatelessWidget {
  final int heightFt;
  final int heightInches;
  final void Function(int value) onFtChanged;
  final void Function(int value) onInchesChanged;

  const FtInchesPicker({
    super.key,
    required this.heightFt,
    required this.heightInches,
    required this.onFtChanged,
    required this.onInchesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: heightFt,
          minValue: 3, // Minimum height in feet
          maxValue: 7, // Maximum height in feet
          onChanged: onFtChanged,
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textMapper: (numberText) {
            // Convert feet number to Arabic if needed
            return isArabic
                ? NumberConversionHelper.convertToArabicNumbers(numberText)
                : numberText;
          },
        ),
        const SizedBox(width: 10),
        NumberPicker(
          value: heightInches,
          minValue: 0, // Minimum height in inches
          maxValue: 11, // Maximum height in inches
          onChanged: onInchesChanged,
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textMapper: (numberText) {
            // Convert inches number to Arabic if needed
            return isArabic
                ? NumberConversionHelper.convertToArabicNumbers(numberText)
                : numberText;
          },
        ),
      ],
    );
  }
}
