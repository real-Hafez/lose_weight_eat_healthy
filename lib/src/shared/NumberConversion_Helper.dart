class NumberConversionHelper {
  // This method converts English numbers to Arabic numerals if the user make it before arabic language
  static String convertToArabicNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => arabicNumbers[int.parse(match.group(0)!)]!,
    );
  }
}
