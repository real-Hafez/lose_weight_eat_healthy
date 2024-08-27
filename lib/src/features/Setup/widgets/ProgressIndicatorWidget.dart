import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.5,
      backgroundColor: Colors.grey[300],
      color: Colors.green,
      minHeight: 4,
    );
  }
}
