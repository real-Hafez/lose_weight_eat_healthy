import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/widgets/streak.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/widgets/water_home_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const streak(),
          Expanded(child: const water_home_page()),
          SizedBox(
            height: MediaQuery.of(context).size.height * .02,
          ),
        ],
      ),
    );
  }
}
