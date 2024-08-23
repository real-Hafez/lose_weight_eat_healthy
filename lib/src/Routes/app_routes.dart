import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/page/setup.dart';
import 'package:lose_weight_eat_healthy/src/features/home/loginforanother.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/pages/Signup.dart';

class AppRoutes {
  static const String home = '/home';
  static const String toquthions = '/toquthions';
  static const String signUpAndLogin = '/';
  static const String loginForAnother = '/loginforanother';
  static const String signup = '/signup'; 

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case toquthions:
        return MaterialPageRoute(builder: (_) => const Home());
      case signUpAndLogin:
        return MaterialPageRoute(builder: (_) => const Loginforanother());
      case loginForAnother:
        return MaterialPageRoute(builder: (_) => const Loginforanother());
      case signup: // New case for signup
        return MaterialPageRoute(builder: (_) => const Signup());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
