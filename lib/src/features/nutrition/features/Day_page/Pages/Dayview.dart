import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';

class Dayview extends StatefulWidget {
  const Dayview({super.key});

  @override
  _DayviewState createState() => _DayviewState();
}

class _DayviewState extends State<Dayview> {
  bool breakfastMinimized = false;
  bool lunchMinimized = false;
  bool dinnerMinimized = false;
  bool snacksMinimized = false;

  void toggleBreakfastMinimize() {
    setState(() {
      breakfastMinimized = !breakfastMinimized;
    });
  }

  void toggleLunchMinimize() {
    setState(() {
      lunchMinimized = !lunchMinimized;
    });
  }

  void toggleDinnerMinimize() {
    setState(() {
      dinnerMinimized = !dinnerMinimized;
    });
  }

  void toggleSnacksMinimize() {
    setState(() {
      snacksMinimized = !snacksMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Nutrition_Calendar(),
            // const SizedBox(height: 25),
            // const CalorieTrackerWidget(),
            // const SizedBox(height: 25),
            // Meal_Type_Display(
            //   food: "Breakfast",
            //   minmize: breakfastMinimized,
            //   onToggleMinimize: toggleBreakfastMinimize,
            // ),
            // if (!breakfastMinimized) const Food_Card_Breakfast(),
            // Meal_Type_Display(
            //   food: "Lunch",
            //   minmize: lunchMinimized,
            //   onToggleMini mize: toggleLunchMinimize,
            // ),
            // if (!lunchMinimized) const Food_Card_Lunch(),
            // Meal_Type_Display(
            //   food: "Dinner",
            //   minmize: dinnerMinimized,
            //   onToggleMinimize: toggleDinnerMinimize,
            // ),
            // if (!dinnerMinimized) const Food_Card_Dinner(),
            // Meal_Type_Display(
            //   food: "Snacks",
            //   minmize: snacksMinimized,
            //   onToggleMinimize: toggleSnacksMinimize,
            // ),
            // if (!snacksMinimized) const Food_Card_snacks(),
          ],
        ),
      ),
    );
  }
}
