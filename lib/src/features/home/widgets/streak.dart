import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class streak extends StatelessWidget {
  const streak({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Ionicons.flame,
          size: MediaQuery.of(context).size.height * .06,
        ),
        const Text(
          '6',
        )
      ],
    );
  }
}
