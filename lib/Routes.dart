import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/home.dart';
import 'package:lose_weight_eat_healthy/loginforanother.dart'; // Ensure this import is correct

class AppRoutes {
  static const String home = '/home';
  static const String toquthions = '/toquthions';
  static const String signUpAndLogin = '/';
  static const String loginForAnother = '/loginforanother';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case toquthions:
        return MaterialPageRoute(
            builder: (_) =>
                const Home()); // Ensure the correct screen is used here
      case signUpAndLogin:
        return MaterialPageRoute(builder: (_) => const Loginforanother());
      case loginForAnother:
        return MaterialPageRoute(builder: (_) => const Loginforanother());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
