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

  /// `Welcome to your journey toward a healthier and happier you! Our app is here to support you every step of the way with a range of free features designed to help you reach your goals effortlessly.`
  String get welcomeonboarding {
    return Intl.message(
      'Welcome to your journey toward a healthier and happier you! Our app is here to support you every step of the way with a range of free features designed to help you reach your goals effortlessly.',
      name: 'welcomeonboarding',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Gender`
  String get genderselect {
    return Intl.message(
      'Select Your Gender',
      name: 'genderselect',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get man {
    return Intl.message(
      'Male',
      name: 'man',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `What's your height?`
  String get heigh {
    return Intl.message(
      'What\'s your height?',
      name: 'heigh',
      desc: '',
      args: [],
    );
  }

  /// `cm`
  String get cm {
    return Intl.message(
      'cm',
      name: 'cm',
      desc: '',
      args: [],
    );
  }

  /// `ft`
  String get ft {
    return Intl.message(
      'ft',
      name: 'ft',
      desc: '',
      args: [],
    );
  }

  /// `What's your weight?`
  String get weight {
    return Intl.message(
      'What\'s your weight?',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `kg`
  String get kg {
    return Intl.message(
      'kg',
      name: 'kg',
      desc: '',
      args: [],
    );
  }

  /// `lb`
  String get lb {
    return Intl.message(
      'lb',
      name: 'lb',
      desc: '',
      args: [],
    );
  }

  /// `Put a Short term goal`
  String get WeightLoss {
    return Intl.message(
      'Put a Short term goal',
      name: 'WeightLoss',
      desc: '',
      args: [],
    );
  }

  /// `gain`
  String get gain {
    return Intl.message(
      'gain',
      name: 'gain',
      desc: '',
      args: [],
    );
  }

  /// `lose`
  String get lose {
    return Intl.message(
      'lose',
      name: 'lose',
      desc: '',
      args: [],
    );
  }

  /// `You are going to`
  String get loseorgainweight {
    return Intl.message(
      'You are going to',
      name: 'loseorgainweight',
      desc: '',
      args: [],
    );
  }

  /// `This will take approximately`
  String get approximately {
    return Intl.message(
      'This will take approximately',
      name: 'approximately',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Choose your body fat percentage`
  String get bodyfatwoman {
    return Intl.message(
      'Choose your body fat percentage',
      name: 'bodyfatwoman',
      desc: '',
      args: [],
    );
  }

  /// `Choose your body fat percentage`
  String get bodyfatman {
    return Intl.message(
      'Choose your body fat percentage',
      name: 'bodyfatman',
      desc: '',
      args: [],
    );
  }

  /// `What Water Measurement Units do you use`
  String get Water {
    return Intl.message(
      'What Water Measurement Units do you use',
      name: 'Water',
      desc: '',
      args: [],
    );
  }

  /// `Select unit:`
  String get unit {
    return Intl.message(
      'Select unit:',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `mL`
  String get mL {
    return Intl.message(
      'mL',
      name: 'mL',
      desc: '',
      args: [],
    );
  }

  /// `L`
  String get Litres {
    return Intl.message(
      'L',
      name: 'Litres',
      desc: '',
      args: [],
    );
  }

  /// `US oz`
  String get USoz {
    return Intl.message(
      'US oz',
      name: 'USoz',
      desc: '',
      args: [],
    );
  }

  /// `You will need to drink around:`
  String get howmanywater {
    return Intl.message(
      'You will need to drink around:',
      name: 'howmanywater',
      desc: '',
      args: [],
    );
  }

  /// `per day`
  String get perday {
    return Intl.message(
      'per day',
      name: 'perday',
      desc: '',
      args: [],
    );
  }

  /// `Wake-up Time:`
  String get wakeup {
    return Intl.message(
      'Wake-up Time:',
      name: 'wakeup',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Time:`
  String get SleepTime {
    return Intl.message(
      'Sleep Time:',
      name: 'SleepTime',
      desc: '',
      args: [],
    );
  }

  /// `waking time`
  String get wakeupclock {
    return Intl.message(
      'waking time',
      name: 'wakeupclock',
      desc: '',
      args: [],
    );
  }

  /// `sleeping time`
  String get sleepingclock {
    return Intl.message(
      'sleeping time',
      name: 'sleepingclock',
      desc: '',
      args: [],
    );
  }

  /// `Water is the driving force of all nature.`
  String get quote {
    return Intl.message(
      'Water is the driving force of all nature.',
      name: 'quote',
      desc: '',
      args: [],
    );
  }

  /// `- Leonardo da Vinci`
  String get quotesaider {
    return Intl.message(
      '- Leonardo da Vinci',
      name: 'quotesaider',
      desc: '',
      args: [],
    );
  }

  /// `The best way to achieve your dreams is to keep them in sight. That's why you need to add this widget to your home screen.`
  String get waterwidget {
    return Intl.message(
      'The best way to achieve your dreams is to keep them in sight. That\'s why you need to add this widget to your home screen.',
      name: 'waterwidget',
      desc: '',
      args: [],
    );
  }

  /// `Add the widget`
  String get addwidget {
    return Intl.message(
      'Add the widget',
      name: 'addwidget',
      desc: '',
      args: [],
    );
  }

  /// `Making your workout Routines...`
  String get setp1 {
    return Intl.message(
      'Making your workout Routines...',
      name: 'setp1',
      desc: '',
      args: [],
    );
  }

  /// `Making your Nutrition...`
  String get step2 {
    return Intl.message(
      'Making your Nutrition...',
      name: 'step2',
      desc: '',
      args: [],
    );
  }

  /// `Set Up Your water reminders`
  String get step3 {
    return Intl.message(
      'Set Up Your water reminders',
      name: 'step3',
      desc: '',
      args: [],
    );
  }

  /// `Just 30 days to reach your goal, try to achieve our dream`
  String get motivationalText {
    return Intl.message(
      'Just 30 days to reach your goal, try to achieve our dream',
      name: 'motivationalText',
      desc: '',
      args: [],
    );
  }

  /// `Start activating your dream`
  String get buttonText {
    return Intl.message(
      'Start activating your dream',
      name: 'buttonText',
      desc: '',
      args: [],
    );
  }

  /// `What is your preferred language for using the app?`
  String get preferlanguage {
    return Intl.message(
      'What is your preferred language for using the app?',
      name: 'preferlanguage',
      desc: '',
      args: [],
    );
  }

  /// `arabic`
  String get arabic {
    return Intl.message(
      'arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `english`
  String get english {
    return Intl.message(
      'english',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `No Restrictions`
  String get Restrictions {
    return Intl.message(
      'No Restrictions',
      name: 'Restrictions',
      desc: '',
      args: [],
    );
  }

  /// `Exclude`
  String get Exclude {
    return Intl.message(
      'Exclude',
      name: 'Exclude',
      desc: '',
      args: [],
    );
  }

  /// `Vegetarian`
  String get Vegetarian {
    return Intl.message(
      'Vegetarian',
      name: 'Vegetarian',
      desc: '',
      args: [],
    );
  }

  /// `Vegan`
  String get Vegan {
    return Intl.message(
      'Vegan',
      name: 'Vegan',
      desc: '',
      args: [],
    );
  }

  /// `Keto`
  String get Keto {
    return Intl.message(
      'Keto',
      name: 'Keto',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Dietary Preference`
  String get diet {
    return Intl.message(
      'Choose Your Dietary Preference',
      name: 'diet',
      desc: '',
      args: [],
    );
  }

  /// `Select the diet that best suits you.`
  String get diet_selective {
    return Intl.message(
      'Select the diet that best suits you.',
      name: 'diet_selective',
      desc: '',
      args: [],
    );
  }

  /// `nothing`
  String get nothing {
    return Intl.message(
      'nothing',
      name: 'nothing',
      desc: '',
      args: [],
    );
  }

  /// `meat`
  String get meat {
    return Intl.message(
      'meat',
      name: 'meat',
      desc: '',
      args: [],
    );
  }

  /// `all animal products`
  String get allanimalproducts {
    return Intl.message(
      'all animal products',
      name: 'allanimalproducts',
      desc: '',
      args: [],
    );
  }

  /// `Carbs, sugar, grains`
  String get Carbssugargrains {
    return Intl.message(
      'Carbs, sugar, grains',
      name: 'Carbssugargrains',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Goal`
  String get Goal {
    return Intl.message(
      'Select Your Goal',
      name: 'Goal',
      desc: '',
      args: [],
    );
  }

  /// `Lose Weight`
  String get LoseWeight {
    return Intl.message(
      'Lose Weight',
      name: 'LoseWeight',
      desc: '',
      args: [],
    );
  }

  /// `Maintain Weight`
  String get MaintainWeight {
    return Intl.message(
      'Maintain Weight',
      name: 'MaintainWeight',
      desc: '',
      args: [],
    );
  }

  /// `Gain Weight `
  String get GainWeight {
    return Intl.message(
      'Gain Weight ',
      name: 'GainWeight',
      desc: '',
      args: [],
    );
  }

  /// `Set Your Short-Term Weight`
  String get short_term {
    return Intl.message(
      'Set Your Short-Term Weight',
      name: 'short_term',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get Maintenance {
    return Intl.message(
      'Maintenance',
      name: 'Maintenance',
      desc: '',
      args: [],
    );
  }

  /// `I want to achieve my goal in...`
  String get active_my_goal {
    return Intl.message(
      'I want to achieve my goal in...',
      name: 'active_my_goal',
      desc: '',
      args: [],
    );
  }

  /// `1 week`
  String get one_week {
    return Intl.message(
      '1 week',
      name: 'one_week',
      desc: '',
      args: [],
    );
  }

  /// `2 weeks`
  String get two_weeks {
    return Intl.message(
      '2 weeks',
      name: 'two_weeks',
      desc: '',
      args: [],
    );
  }

  /// `1 month`
  String get one_month {
    return Intl.message(
      '1 month',
      name: 'one_month',
      desc: '',
      args: [],
    );
  }

  /// `2 months`
  String get two_months {
    return Intl.message(
      '2 months',
      name: 'two_months',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get Custom {
    return Intl.message(
      'Custom',
      name: 'Custom',
      desc: '',
      args: [],
    );
  }

  /// `recommended for you`
  String get recommended {
    return Intl.message(
      'recommended for you',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `Your BMI`
  String get Bmi {
    return Intl.message(
      'Your BMI',
      name: 'Bmi',
      desc: '',
      args: [],
    );
  }

  /// `Severe Thinness`
  String get severeThinness {
    return Intl.message(
      'Severe Thinness',
      name: 'severeThinness',
      desc: '',
      args: [],
    );
  }

  /// `Moderate Thinness`
  String get moderateThinness {
    return Intl.message(
      'Moderate Thinness',
      name: 'moderateThinness',
      desc: '',
      args: [],
    );
  }

  /// `Mild Thinness`
  String get mildThinness {
    return Intl.message(
      'Mild Thinness',
      name: 'mildThinness',
      desc: '',
      args: [],
    );
  }

  /// `Normal weight`
  String get normalWeight {
    return Intl.message(
      'Normal weight',
      name: 'normalWeight',
      desc: '',
      args: [],
    );
  }

  /// `Overweight`
  String get overweight {
    return Intl.message(
      'Overweight',
      name: 'overweight',
      desc: '',
      args: [],
    );
  }

  /// `Obese Class I`
  String get obeseClassI {
    return Intl.message(
      'Obese Class I',
      name: 'obeseClassI',
      desc: '',
      args: [],
    );
  }

  /// `Obese Class II`
  String get obeseClassII {
    return Intl.message(
      'Obese Class II',
      name: 'obeseClassII',
      desc: '',
      args: [],
    );
  }

  /// `Obese Class III`
  String get obeseClassIII {
    return Intl.message(
      'Obese Class III',
      name: 'obeseClassIII',
      desc: '',
      args: [],
    );
  }

  /// `Keep up the good work and maintain a healthy lifestyle!`
  String get healthylifestyle {
    return Intl.message(
      'Keep up the good work and maintain a healthy lifestyle!',
      name: 'healthylifestyle',
      desc: '',
      args: [],
    );
  }

  /// `A healthier you is within reach! Consider consulting a healthcare professional, and explore our app's nutrition plans to support your journey.`
  String get severeThinnessRec {
    return Intl.message(
      'A healthier you is within reach! Consider consulting a healthcare professional, and explore our app\'s nutrition plans to support your journey.',
      name: 'severeThinnessRec',
      desc: '',
      args: [],
    );
  }

  /// `A balanced diet can make a world of difference. Our nutrition plans are here to help you reach your ideal weight.`
  String get moderateThinnessRec {
    return Intl.message(
      'A balanced diet can make a world of difference. Our nutrition plans are here to help you reach your ideal weight.',
      name: 'moderateThinnessRec',
      desc: '',
      args: [],
    );
  }

  /// `Small changes can lead to great results! Try our healthy meal options to get closer to your wellness goals.`
  String get mildThinnessRec {
    return Intl.message(
      'Small changes can lead to great results! Try our healthy meal options to get closer to your wellness goals.',
      name: 'mildThinnessRec',
      desc: '',
      args: [],
    );
  }

  /// `You’re on the right track! Keep up the great habits and explore new ways to maintain a balanced lifestyle.`
  String get normalRec {
    return Intl.message(
      'You’re on the right track! Keep up the great habits and explore new ways to maintain a balanced lifestyle.',
      name: 'normalRec',
      desc: '',
      args: [],
    );
  }

  /// `You're closer to a healthier weight than you think! A nutritious diet and regular exercise can make a big difference. Let’s start together!`
  String get overweightRec {
    return Intl.message(
      'You\'re closer to a healthier weight than you think! A nutritious diet and regular exercise can make a big difference. Let’s start together!',
      name: 'overweightRec',
      desc: '',
      args: [],
    );
  }

  /// `With dedication and the right choices, a healthier weight is achievable. Explore our meal plans and workouts tailored to support your journey.`
  String get obeseClassIRec {
    return Intl.message(
      'With dedication and the right choices, a healthier weight is achievable. Explore our meal plans and workouts tailored to support your journey.',
      name: 'obeseClassIRec',
      desc: '',
      args: [],
    );
  }

  /// `Your health is a priority. Our app can guide you with personalized nutrition and activity plans to get closer to your goal.`
  String get obeseClassIIRec {
    return Intl.message(
      'Your health is a priority. Our app can guide you with personalized nutrition and activity plans to get closer to your goal.',
      name: 'obeseClassIIRec',
      desc: '',
      args: [],
    );
  }

  /// `Together, we can make a difference in your health. Consult a healthcare provider and start with our nutrition and wellness options for a fresh start.`
  String get obeseClassIIIRec {
    return Intl.message(
      'Together, we can make a difference in your health. Consult a healthcare provider and start with our nutrition and wellness options for a fresh start.',
      name: 'obeseClassIIIRec',
      desc: '',
      args: [],
    );
  }

  /// `Goal`
  String get Goall {
    return Intl.message(
      'Goal',
      name: 'Goall',
      desc: '',
      args: [],
    );
  }

  /// `weight loss`
  String get Weightlose {
    return Intl.message(
      'weight loss',
      name: 'Weightlose',
      desc: '',
      args: [],
    );
  }

  /// `weight gain`
  String get weightgain {
    return Intl.message(
      'weight gain',
      name: 'weightgain',
      desc: '',
      args: [],
    );
  }

  /// `kg/week`
  String get kgweek {
    return Intl.message(
      'kg/week',
      name: 'kgweek',
      desc: '',
      args: [],
    );
  }

  /// `lb/week`
  String get lbweek {
    return Intl.message(
      'lb/week',
      name: 'lbweek',
      desc: '',
      args: [],
    );
  }

  /// `Gradual`
  String get Gradual {
    return Intl.message(
      'Gradual',
      name: 'Gradual',
      desc: '',
      args: [],
    );
  }

  /// `Faster`
  String get Faster {
    return Intl.message(
      'Faster',
      name: 'Faster',
      desc: '',
      args: [],
    );
  }

  /// `Custom goal`
  String get customgoal {
    return Intl.message(
      'Custom goal',
      name: 'customgoal',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get week {
    return Intl.message(
      'week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `weekly goal`
  String get weeklygoal {
    return Intl.message(
      'weekly goal',
      name: 'weeklygoal',
      desc: '',
      args: [],
    );
  }

  /// `Enter your desired weekly weight`
  String get desiredweekly {
    return Intl.message(
      'Enter your desired weekly weight',
      name: 'desiredweekly',
      desc: '',
      args: [],
    );
  }

  /// `Choose a custom goal like 0.75 kilograms`
  String get ex {
    return Intl.message(
      'Choose a custom goal like 0.75 kilograms',
      name: 'ex',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid goal within a healthy range.`
  String get validgoal {
    return Intl.message(
      'Please enter a valid goal within a healthy range.',
      name: 'validgoal',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number.`
  String get vaildnumber {
    return Intl.message(
      'Please enter a valid number.',
      name: 'vaildnumber',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Target Weight`
  String get TargetWeight {
    return Intl.message(
      'Target Weight',
      name: 'TargetWeight',
      desc: '',
      args: [],
    );
  }

  /// `Healthy range:`
  String get Healthyrange {
    return Intl.message(
      'Healthy range:',
      name: 'Healthyrange',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a weight within the range`
  String get rangeweight {
    return Intl.message(
      'Please enter a weight within the range',
      name: 'rangeweight',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Height`
  String get EnterValidHeight {
    return Intl.message(
      'Enter Valid Height',
      name: 'EnterValidHeight',
      desc: '',
      args: [],
    );
  }

  /// `Estimated time to achieve your goal weight:`
  String get Estimatedtime {
    return Intl.message(
      'Estimated time to achieve your goal weight:',
      name: 'Estimatedtime',
      desc: '',
      args: [],
    );
  }

  /// `Your journey to success starts here!`
  String get Yourjourney {
    return Intl.message(
      'Your journey to success starts here!',
      name: 'Yourjourney',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Your target weight is below the healthy minimum of`
  String get belowweigh {
    return Intl.message(
      'Your target weight is below the healthy minimum of',
      name: 'belowweigh',
      desc: '',
      args: [],
    );
  }

  /// `Please set a higher target.`
  String get highertarget {
    return Intl.message(
      'Please set a higher target.',
      name: 'highertarget',
      desc: '',
      args: [],
    );
  }

  /// `Your target weight is above the healthy maximum of`
  String get maxweigh {
    return Intl.message(
      'Your target weight is above the healthy maximum of',
      name: 'maxweigh',
      desc: '',
      args: [],
    );
  }

  /// `Please set a lower target.`
  String get lowertarget {
    return Intl.message(
      'Please set a lower target.',
      name: 'lowertarget',
      desc: '',
      args: [],
    );
  }

  /// `s`
  String get s {
    return Intl.message(
      's',
      name: 's',
      desc: '',
      args: [],
    );
  }

  /// `How old are you`
  String get howold {
    return Intl.message(
      'How old are you',
      name: 'howold',
      desc: '',
      args: [],
    );
  }

  /// `Sedentary`
  String get titlesedentary {
    return Intl.message(
      'Sedentary',
      name: 'titlesedentary',
      desc: '',
      args: [],
    );
  }

  /// `Little or no exercise. Example: Office work, sitting most of the day.`
  String get descriptionsedentary {
    return Intl.message(
      'Little or no exercise. Example: Office work, sitting most of the day.',
      name: 'descriptionsedentary',
      desc: '',
      args: [],
    );
  }

  /// `Lightly Active`
  String get titlelightlyactive {
    return Intl.message(
      'Lightly Active',
      name: 'titlelightlyactive',
      desc: '',
      args: [],
    );
  }

  /// `Light exercise/sports 1-3 days/week. Example: Walking, light gym sessions.`
  String get descriptionlightlyactive {
    return Intl.message(
      'Light exercise/sports 1-3 days/week. Example: Walking, light gym sessions.',
      name: 'descriptionlightlyactive',
      desc: '',
      args: [],
    );
  }

  /// `Moderately Active`
  String get titlemoderatelyactive {
    return Intl.message(
      'Moderately Active',
      name: 'titlemoderatelyactive',
      desc: '',
      args: [],
    );
  }

  /// `Moderate exercise/sports 3-5 days/week. Example: Gym 3-5 days/week.`
  String get descriptionmoderatelyactive {
    return Intl.message(
      'Moderate exercise/sports 3-5 days/week. Example: Gym 3-5 days/week.',
      name: 'descriptionmoderatelyactive',
      desc: '',
      args: [],
    );
  }

  /// `Very Active`
  String get titleveryactive {
    return Intl.message(
      'Very Active',
      name: 'titleveryactive',
      desc: '',
      args: [],
    );
  }

  /// `Hard exercise/sports 6-7 days/week. Example: Intensive gym training.`
  String get descriptionveryactive {
    return Intl.message(
      'Hard exercise/sports 6-7 days/week. Example: Intensive gym training.',
      name: 'descriptionveryactive',
      desc: '',
      args: [],
    );
  }

  /// `Extra Active`
  String get titleextraactive {
    return Intl.message(
      'Extra Active',
      name: 'titleextraactive',
      desc: '',
      args: [],
    );
  }

  /// `Very hard exercise or physical job. Example: Athlete, 2x daily training.`
  String get descriptionextraactive {
    return Intl.message(
      'Very hard exercise or physical job. Example: Athlete, 2x daily training.',
      name: 'descriptionextraactive',
      desc: '',
      args: [],
    );
  }

  /// `What is your activity level?`
  String get activitylevel {
    return Intl.message(
      'What is your activity level?',
      name: 'activitylevel',
      desc: '',
      args: [],
    );
  }

  /// `Calories Chart`
  String get CaloriesChart {
    return Intl.message(
      'Calories Chart',
      name: 'CaloriesChart',
      desc: '',
      args: [],
    );
  }

  /// `Protein`
  String get Protein {
    return Intl.message(
      'Protein',
      name: 'Protein',
      desc: '',
      args: [],
    );
  }

  /// `Carbs `
  String get Carbs {
    return Intl.message(
      'Carbs ',
      name: 'Carbs',
      desc: '',
      args: [],
    );
  }

  /// `fats`
  String get fats {
    return Intl.message(
      'fats',
      name: 'fats',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get Balanced {
    return Intl.message(
      'Balanced',
      name: 'Balanced',
      desc: '',
      args: [],
    );
  }

  /// `Low Fat`
  String get LowFat {
    return Intl.message(
      'Low Fat',
      name: 'LowFat',
      desc: '',
      args: [],
    );
  }

  /// `Low Carb`
  String get LowCarb {
    return Intl.message(
      'Low Carb',
      name: 'LowCarb',
      desc: '',
      args: [],
    );
  }

  /// `High Protein`
  String get HighProtein {
    return Intl.message(
      'High Protein',
      name: 'HighProtein',
      desc: '',
      args: [],
    );
  }

  /// `grams/day`
  String get gramsday {
    return Intl.message(
      'grams/day',
      name: 'gramsday',
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
