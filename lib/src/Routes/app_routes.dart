import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/page/BottomNavBar_main.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/pages/Signup.dart';

class AppRoutes {
  static const String setup_screen = '/setup';
  static const String toquthions = '/toquthions';
  static const String signUpAndLogin = '/';
  static const String loginForAnother = '/loginforanother';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case setup_screen:
        return MaterialPageRoute(builder: (_) => const setup());
      case toquthions:
        return MaterialPageRoute(builder: (_) => const setup());
      case signUpAndLogin:
        return MaterialPageRoute(builder: (_) => const BottomNavBar_main());
      case loginForAnother:
        return MaterialPageRoute(builder: (_) => const BottomNavBar_main());
      case signup:
        return MaterialPageRoute(builder: (_) => const Signup());
      default:
        return MaterialPageRoute(builder: (_) => const setup());
    }
  }
}
