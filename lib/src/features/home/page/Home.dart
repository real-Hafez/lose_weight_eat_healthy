import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/home/widgets/bottom_nav_bar.dart';
import 'package:lose_weight_eat_healthy/src/features/home/widgets/calender_for_training_water.dart';
import 'package:lose_weight_eat_healthy/src/features/home/widgets/streak.dart';
import 'package:lose_weight_eat_healthy/src/features/home/widgets/water_home_page.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            streak(),
            calender_for_training_water(),
            water_home_page(),
            Expanded(
              child: BottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
