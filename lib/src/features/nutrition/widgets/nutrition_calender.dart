import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class nutrition_calender extends StatelessWidget {
  const nutrition_calender({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false, // No need for the header in this style
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true, // Highlight today's date
        todayDecoration: BoxDecoration(
          color: Colors
              .transparent, // No background for today (or customize as needed)
          shape: BoxShape.values[0],
          border: Border.all(
              color: Colors.purple, width: 2), // Black border for today's date
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.purple, // Background color for selected day
          borderRadius:
              BorderRadius.circular(20), // Oval shape for selected day
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white, // Text color for selected day
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.white, // Background color for unselected days
          borderRadius:
              BorderRadius.circular(20), // Oval shape for unselected days
          border: Border.all(
              color: Colors.transparent), // No border for unselected days
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.white, // Background for weekend days
          borderRadius: BorderRadius.circular(20), // Oval shape for weekends
          border: Border.all(color: Colors.transparent),
        ),
        todayTextStyle: const TextStyle(
          color: Colors.white, // Text color for today
        ),
        defaultTextStyle: const TextStyle(
          color: Colors.black, // Default text color
        ),
        weekendTextStyle: const TextStyle(
          color: Colors.black, // Weekend text color
        ),
        cellMargin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 4), // Adjust space around cells
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.grey, // Style for weekday labels
          fontSize: 12,
        ),
        weekendStyle: TextStyle(
          color: Colors.grey, // Style for weekend labels
          fontSize: 12,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // Your logic when a day is selected
      },
    );
  }
}
