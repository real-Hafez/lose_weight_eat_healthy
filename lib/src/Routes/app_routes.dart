import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/home/page/Home.dart';
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
        return MaterialPageRoute(builder: (_) => const Home());
      case loginForAnother:
        return MaterialPageRoute(builder: (_) => const Home());
      case signup: 
        return MaterialPageRoute(builder: (_) => const Signup());
      default:
        return MaterialPageRoute(builder: (_) => const setup());
    }
  }
}
