import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Navigator_Bar/widgets/bottom_nav_bar.dart';

class BottomNavBar_main extends StatelessWidget {
  const BottomNavBar_main({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: BottomNavBar()),
          ],
        ),
      ),
    );
  }
}
