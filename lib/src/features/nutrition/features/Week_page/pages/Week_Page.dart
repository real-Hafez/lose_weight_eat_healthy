import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/widgets/calender_widget.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: CalendarWidgetWeek()),
      ],
    );
  }
}
