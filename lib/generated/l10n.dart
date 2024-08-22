// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `skip`
  String get skipbutton {
    return Intl.message(
      'skip',
      name: 'skipbutton',
      desc: '',
      args: [],
    );
  }

  /// `create new account`
  String get new_account {
    return Intl.message(
      'create new account',
      name: 'new_account',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Perfect Cardio Routine`
  String get main_text_FirstOnboardingPage {
    return Intl.message(
      'Find Your Perfect Cardio Routine',
      name: 'main_text_FirstOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Browse videos that match your fitness level and help you reach your cardio goals`
  String get sub_text_FirstOnboardingPage {
    return Intl.message(
      'Browse videos that match your fitness level and help you reach your cardio goals',
      name: 'sub_text_FirstOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Quick Recipes, Healthy Results`
  String get main_text_secondOnboardingPage {
    return Intl.message(
      'Quick Recipes, Healthy Results',
      name: 'main_text_secondOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Discover the quickest way to nutritious meals that help you stay fit and healthy.`
  String get sub_text_secondOnboardingPage {
    return Intl.message(
      'Discover the quickest way to nutritious meals that help you stay fit and healthy.',
      name: 'sub_text_secondOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Absolutely Free for Your Health`
  String get main_text_ThirdOnboardingPage {
    return Intl.message(
      'Absolutely Free for Your Health',
      name: 'main_text_ThirdOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `It’s all free! We want you to get fit and healthy, so enjoy our content with no cost.`
  String get sub_text_ThirdOnboardingPage {
    return Intl.message(
      'It’s all free! We want you to get fit and healthy, so enjoy our content with no cost.',
      name: 'sub_text_ThirdOnboardingPage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
