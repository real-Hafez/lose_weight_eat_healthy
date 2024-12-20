import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(LocaleCubit._getDeviceLocale());

  Future<void> initializeLocale() async {
    final savedLocale = await _getSavedLocale();
    emit(savedLocale ?? _getDeviceLocale());
  }

  static Future<Locale?> _getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode');
      final countryCode = prefs.getString('countryCode');
      if (languageCode != null) {
        return Locale(languageCode, countryCode);
      }
    } catch (e) {
      debugPrint('Error retrieving saved locale: $e');
    }
    return null;
  }

  Future<void> updateLocale(Locale newLocale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
      await prefs.setString('countryCode', newLocale.countryCode ?? '');
      emit(newLocale);
    } catch (e) {
      debugPrint('Error updating locale: $e');
    }
  }

  static Locale _getDeviceLocale() {
    final deviceLocale = window.locale;
    return deviceLocale.languageCode == 'ar'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');
  }
}
