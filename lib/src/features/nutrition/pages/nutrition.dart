import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/service/FoodService.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';

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

class ToggleButtonDayWeek extends StatefulWidget {
  const ToggleButtonDayWeek({super.key});

  @override
  _ToggleButtonDayWeekState createState() => _ToggleButtonDayWeekState();
}

class _ToggleButtonDayWeekState extends State<ToggleButtonDayWeek> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final activeTextStyle = TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          color: Colors.white,
        );
        final inactiveTextStyle = TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          color: Colors.black54,
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Center(
            child: Container(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToggleButton(
                    'Day',
                    index: 0,
                    isSelected: selectedIndex == 0,
                    textStyle: selectedIndex == 0
                        ? activeTextStyle
                        : inactiveTextStyle,
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    'Week',
                    index: 1,
                    isSelected: selectedIndex == 1,
                    textStyle: selectedIndex == 1
                        ? activeTextStyle
                        : inactiveTextStyle,
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    'Shopping List',
                    index: 2,
                    isSelected: selectedIndex == 2,
                    textStyle: selectedIndex == 2
                        ? activeTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height * .02,
                          )
                        : inactiveTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height * .02,
                          ),
                    constraints: constraints,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(
    String label, {
    required int index,
    required bool isSelected,
    required TextStyle textStyle,
    required BoxConstraints constraints,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('Switched to: $label');
      },
      child: SizedBox(
        width: constraints.maxWidth / 3,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurpleAccent.withOpacity(0.8)
                : Colors.grey[300],
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: Colors.red, width: 3),
                  )
                : null,
          ),
          child: Center(
            child: AutoSizeText(
              label,
              style: textStyle,
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
