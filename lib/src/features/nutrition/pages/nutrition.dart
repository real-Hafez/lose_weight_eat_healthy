import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Nutrition extends StatelessWidget {
  final FoodService foodService = FoodService();

  Nutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          ToggleButtonDayWeek(),
          SizedBox(height: 25),
          nutrition_calender(),
          SizedBox(height: 25),
          CalorieTrackerWidget(),
          SizedBox(height: 25),
          Meal_Type_Display(food: "Breakfast"),
          SizedBox(height: 1),
          Food_days(),
        ],
      ),
    );
  }
}

class ToggleButtonDayWeek extends StatelessWidget {
  const ToggleButtonDayWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Center(
            child: ToggleSwitch(
              activeBorders: [
                Border(
                  bottom: BorderSide(color: Colors.red, width: 3),
                ),
              ],
              activeBgColor: [
                Colors.deepPurpleAccent.withOpacity(0.8),
              ],
              inactiveBgColor: Colors.grey[300],
              activeFgColor: Colors.white,
              inactiveFgColor: Colors.black54,
              borderColor: [Colors.deepPurpleAccent],
              animate: true,
              initialLabelIndex: 0,
              totalSwitches: 3,
              labels: const ['Day', 'Week', 'Shopping List'],
              minWidth: constraints.maxWidth / 3,
              customTextStyles: [
                TextStyle(fontSize: MediaQuery.of(context).size.height * .03),
                TextStyle(fontSize: MediaQuery.of(context).size.height * .03),
                TextStyle(fontSize: MediaQuery.of(context).size.height * .020),
              ],
              centerText: true,
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          ),
        );
      },
    );
  }
}
