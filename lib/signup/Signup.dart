import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/signup_textfield_and_ui.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: signup_textfields(),
        ),
      ),
    );
  }
}
