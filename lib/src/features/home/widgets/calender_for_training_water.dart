import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calender_for_training_water extends StatelessWidget {
  final Set<DateTime> goalReachedDays;

  const calender_for_training_water({super.key, required this.goalReachedDays});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 7)),
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      sixWeekMonthsEnforced: false,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (goalReachedDays
              .contains(DateTime(date.year, date.month, date.day))) {
            return const Icon(Icons.check_circle, color: Colors.green);
          }
          return null;
        },
      ),
    );
  }
}
