import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calender_for_training_water extends StatelessWidget {
  final Map<DateTime, bool?> goalCompletionStatus; // Null means waiting
  final Function(DateTime) onDaySelected; // Callback for day selection

  const calender_for_training_water({
    super.key,
    required this.goalCompletionStatus,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return TableCalendar(
      
      firstDay: today.subtract(const Duration(days: 30)),
      lastDay: today,
      focusedDay: today, // Set focused day to today
      selectedDayPredicate: (day) =>
          isSameDay(day, today), // Mark today as selected
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      sixWeekMonthsEnforced: false,
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay); // Call the callback
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final status =
              goalCompletionStatus[DateTime(date.year, date.month, date.day)];

          if (status == null && today.day == date.day) {
            return const Icon(Icons.hourglass_empty, color: Colors.orange);
          } else if (status == true) {
            return const Icon(Icons.check_circle, color: Colors.green);
          } else if (status == false) {
            return const Icon(Icons.close, color: Colors.red);
          } else {
            return null;
          }
        },
      ),
    );
  }
}
