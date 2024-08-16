import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/SignIn/widget/login_textfield_and_ui.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/create_new_account.dart';
import 'package:lose_weight_eat_healthy/signup/widgets/signup_textfield_and_ui.dart';

class Signinscreen extends StatelessWidget {
  const Signinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: LoginTextfieldAndUi(),
        ),
      ),
    );
  }
}
