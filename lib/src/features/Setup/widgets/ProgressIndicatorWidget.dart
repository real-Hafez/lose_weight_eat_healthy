import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  @override
  double value;

  ProgressIndicatorWidget({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.grey[300],
      color: Colors.green,
      minHeight: 4,
    );
  }
}
