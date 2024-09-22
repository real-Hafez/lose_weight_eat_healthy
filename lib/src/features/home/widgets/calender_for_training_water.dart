import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calender_for_training_water extends StatelessWidget {
  final Map<DateTime, bool?> goalCompletionStatus; // Null means waiting

  const calender_for_training_water({
    super.key,
    required this.goalCompletionStatus,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 30)),
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      sixWeekMonthsEnforced: false,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final status =
              goalCompletionStatus[DateTime(date.year, date.month, date.day)];

          if (status == null && DateTime.now().day == date.day) {
            // Show waiting icon for the current day
            return const Icon(Icons.hourglass_empty, color: Colors.orange);
          } else if (status == true) {
            // Show checkmark for success
            return const Icon(Icons.check_circle, color: Colors.green);
          } else if (status == false) {
            // Show X for failure
            return const Icon(Icons.close, color: Colors.red);
          } else {
            // Future dates should show nothing or default behavior
            return null;
          }
        },
      ),
    );
  }
}
