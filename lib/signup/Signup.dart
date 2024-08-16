import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/SignupIntroSection.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/signup_textfield_and_ui.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/text_field_for_sign_up_and_login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: signup_textfield_and_ui(),
        ),
      ),
    );
  }
}
