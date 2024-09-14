import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text('Login for Anotherr',
            style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
