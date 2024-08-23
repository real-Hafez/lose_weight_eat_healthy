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

  /// `Skip`
  String get skipButton {
    return Intl.message(
      'Skip',
      name: 'skipButton',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get newAccount {
    return Intl.message(
      'Create New Account',
      name: 'newAccount',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Perfect Cardio Routine`
  String get mainTextFirstOnboardingPage {
    return Intl.message(
      'Find Your Perfect Cardio Routine',
      name: 'mainTextFirstOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Browse videos that match your fitness level and help you reach your cardio goals.`
  String get subTextFirstOnboardingPage {
    return Intl.message(
      'Browse videos that match your fitness level and help you reach your cardio goals.',
      name: 'subTextFirstOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Quick Recipes, Healthy Results`
  String get mainTextSecondOnboardingPage {
    return Intl.message(
      'Quick Recipes, Healthy Results',
      name: 'mainTextSecondOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Discover the quickest way to nutritious meals that help you stay fit and healthy.`
  String get subTextSecondOnboardingPage {
    return Intl.message(
      'Discover the quickest way to nutritious meals that help you stay fit and healthy.',
      name: 'subTextSecondOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Absolutely Free for Your Health`
  String get mainTextThirdOnboardingPage {
    return Intl.message(
      'Absolutely Free for Your Health',
      name: 'mainTextThirdOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `It’s all free! We want you to get fit and healthy, so enjoy our content at no cost.`
  String get subTextThirdOnboardingPage {
    return Intl.message(
      'It’s all free! We want you to get fit and healthy, so enjoy our content at no cost.',
      name: 'subTextThirdOnboardingPage',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed`
  String get firstNameHint {
    return Intl.message(
      'Ahmed',
      name: 'firstNameHint',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstNameLabel {
    return Intl.message(
      'First name',
      name: 'firstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Hafez`
  String get lastNameHint {
    return Intl.message(
      'Hafez',
      name: 'lastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastNameLabel {
    return Intl.message(
      'Last name',
      name: 'lastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `ahmed140`
  String get usernameHint {
    return Intl.message(
      'ahmed140',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get usernameLabel {
    return Intl.message(
      'Username',
      name: 'usernameLabel',
      desc: '',
      args: [],
    );
  }

  /// `email@example.com`
  String get emailHint {
    return Intl.message(
      'email@example.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `*********`
  String get passwordHint {
    return Intl.message(
      '*********',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields`
  String get forgetfield {
    return Intl.message(
      'Please fill in all required fields',
      name: 'forgetfield',
      desc: '',
      args: [],
    );
  }

  /// `Username is already taken`
  String get usernametaken {
    return Intl.message(
      'Username is already taken',
      name: 'usernametaken',
      desc: '',
      args: [],
    );
  }

  /// `Do you already have an account?`
  String get promptTextlogin {
    return Intl.message(
      'Do you already have an account?',
      name: 'promptTextlogin',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get actionTextlogin {
    return Intl.message(
      'Log in',
      name: 'actionTextlogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signupbutton {
    return Intl.message(
      'Sign up',
      name: 'signupbutton',
      desc: '',
      args: [],
    );
  }

  /// `Signup successful`
  String get signupSuccessful {
    return Intl.message(
      'Signup successful',
      name: 'signupSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account.`
  String get emailAlreadyInUse {
    return Intl.message(
      'The email address is already in use by another account.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The email address is badly formatted.`
  String get invalidEmail {
    return Intl.message(
      'The email address is badly formatted.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `The password provided is too weak.`
  String get weakPassword {
    return Intl.message(
      'The password provided is too weak.',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again.`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred. Please try again.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update user details. Please try again.`
  String get updateUserDetailsFailed {
    return Intl.message(
      'Failed to update user details. Please try again.',
      name: 'updateUserDetailsFailed',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that email.`
  String get userNotFound {
    return Intl.message(
      'No user found for that email.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password provided for that user.`
  String get wrongPassword {
    return Intl.message(
      'Wrong password provided for that user.',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `This user has been disabled.`
  String get userDisabled {
    return Intl.message(
      'This user has been disabled.',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests. Try again later.`
  String get tooManyRequests {
    return Intl.message(
      'Too many requests. Try again later.',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Please check your connection.`
  String get networkRequestFailed {
    return Intl.message(
      'Network error. Please check your connection.',
      name: 'networkRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Sign-in method not allowed. Please enable the sign-in method in Firebase console.`
  String get operationNotAllowed {
    return Intl.message(
      'Sign-in method not allowed. Please enable the sign-in method in Firebase console.',
      name: 'operationNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Discover our app, it’s`
  String get discoverApp {
    return Intl.message(
      'Discover our app, it’s',
      name: 'discoverApp',
      desc: '',
      args: [],
    );
  }

  /// `PERSONALIZED TRAINING`
  String get personalizedTraining {
    return Intl.message(
      'PERSONALIZED TRAINING',
      name: 'personalizedTraining',
      desc: '',
      args: [],
    );
  }

  /// `DAILY MOTIVATION`
  String get dailyMotivation {
    return Intl.message(
      'DAILY MOTIVATION',
      name: 'dailyMotivation',
      desc: '',
      args: [],
    );
  }

  /// `HEALTHY RECIPE SUGGESTIONS`
  String get healthyRecipeSuggestions {
    return Intl.message(
      'HEALTHY RECIPE SUGGESTIONS',
      name: 'healthyRecipeSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `CUSTOM WORKOUT PLANS`
  String get customWorkoutPlans {
    return Intl.message(
      'CUSTOM WORKOUT PLANS',
      name: 'customWorkoutPlans',
      desc: '',
      args: [],
    );
  }

  /// `PROGRESS TRACKING`
  String get progressTracking {
    return Intl.message(
      'PROGRESS TRACKING',
      name: 'progressTracking',
      desc: '',
      args: [],
    );
  }

  /// `MEAL PLANNING`
  String get mealPlanning {
    return Intl.message(
      'MEAL PLANNING',
      name: 'mealPlanning',
      desc: '',
      args: [],
    );
  }

  /// `EXPERT TRAINING TIPS`
  String get expertTrainingTips {
    return Intl.message(
      'EXPERT TRAINING TIPS',
      name: 'expertTrainingTips',
      desc: '',
      args: [],
    );
  }

  /// `Or login with`
  String get orLoginWith {
    return Intl.message(
      'Or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Or sign up with`
  String get orSignupWith {
    return Intl.message(
      'Or sign up with',
      name: 'orSignupWith',
      desc: '',
      args: [],
    );
  }

  /// ` Login successful`
  String get Loginsuccessful {
    return Intl.message(
      ' Login successful',
      name: 'Loginsuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
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
