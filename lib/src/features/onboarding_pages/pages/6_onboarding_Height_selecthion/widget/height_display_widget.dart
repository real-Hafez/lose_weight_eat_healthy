import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';

class HeightDisplayWidget extends StatelessWidget {
  final int heightCm;
  final int heightFt;
  final int heightInches;
  final String heightUnit;

  const HeightDisplayWidget({
    super.key,
    required this.heightCm,
    required this.heightFt,
    required this.heightInches,
    required this.heightUnit,
  });

  @override
  Widget build(BuildContext context) {
    // Check if Arabic is selected
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final String formattedHeight = heightUnit == 'cm'
        ? '${isArabic ? NumberConversionHelper.convertToArabicNumbers(heightCm.toString()) : heightCm} ${S().cm}'
        : '${isArabic ? NumberConversionHelper.convertToArabicNumbers(heightFt.toString()) : heightFt}\'${isArabic ? NumberConversionHelper.convertToArabicNumbers(heightInches.toString()) : heightInches} ${S().ft}';

    return Center(
      child: Text(
        formattedHeight,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * .15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
