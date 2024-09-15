import 'package:flutter/material.dart';

List<Widget> buildScreens() {
  return [const HomeScreen(), const SettingsScreen(), const HomeScreenb()];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}

class HomeScreenb extends StatelessWidget {
  const HomeScreenb({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Screen')),
    );
  }
}
