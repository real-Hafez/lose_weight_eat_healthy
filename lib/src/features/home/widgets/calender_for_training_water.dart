import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calender_for_training_water extends StatelessWidget {
  const calender_for_training_water({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 13)),
      focusedDay: DateTime.now(),
      sixWeekMonthsEnforced: false,
      headerVisible: false,
      calendarFormat: CalendarFormat.twoWeeks,
    );
  }
}
