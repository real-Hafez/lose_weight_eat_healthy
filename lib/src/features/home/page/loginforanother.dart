import 'package:flutter/material.dart';

class Loginforanother extends StatelessWidget {
  const Loginforanother({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text('Login for Another',
            style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
