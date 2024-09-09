import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Waterpage extends StatelessWidget {
  const Waterpage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
