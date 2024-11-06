import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit()
      : super(_getDeviceLocale()); // Initialize with the device's language

  Future<void> initializeLocale() async {
    final Locale savedLocale = await _getSavedLocale() ??
        _getDeviceLocale(); // Fallback to device locale
    emit(savedLocale);
  }

  static Future<Locale?> _getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('languageCode');
    final String? countryCode = prefs.getString('countryCode');
    if (languageCode != null && countryCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  void updateLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
    await prefs.setString('countryCode', newLocale.countryCode ?? '');
    emit(newLocale);
  }

  // Get the device's current locale and return it, falling back to English if needed
  static Locale _getDeviceLocale() {
    final deviceLocale = window.locale.languageCode;

    // Check if the device's language is Arabic ('ar') or English ('en')
    if (deviceLocale == 'ar') {
      return const Locale(
          'ar', 'SA'); // Set to Arabic if the device is in Arabic
    } else {
      return const Locale('en',
          'US'); // Default to English if the device is in any other language
    }
  }
}
