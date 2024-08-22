import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_getInitialLocale());

  static Locale _getInitialLocale() {
    final Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (deviceLocale.languageCode == 'en' ||
        deviceLocale.languageCode == 'ar') {
      return deviceLocale;
    } else {
      return const Locale('en');
    }
  }

  void updateLocale(Locale newLocale) {
    emit(newLocale);
  }
}
