import 'package:flutter/material.dart';

class Macro_Detail extends StatelessWidget {
  final IconData icon;
  final String label;

  const Macro_Detail({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        SizedBox(height: MediaQuery.sizeOf(context).height * .005),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.sizeOf(context).height * .015,
          ),
        ),
      ],
    );
  }
}
