import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/home.dart';

class AppRoutes {
  static const String home = '/home';
  static const String toquthions = '/toquthions ';
  static const String signUpAndLogin = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case toquthions:
        return MaterialPageRoute(builder: (_) => const Home());
      case signUpAndLogin:
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
