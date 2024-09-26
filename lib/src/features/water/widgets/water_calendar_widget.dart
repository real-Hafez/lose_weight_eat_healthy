import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';

class water_calendar_widget extends StatelessWidget {
  final Function(DateTime) onDaySelected;

  const water_calendar_widget({
    super.key,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        if (state is WaterLoaded) {
          final DateTime today = DateTime.now();

          return TableCalendar(
            firstDay: today.subtract(const Duration(days: 30)),
            lastDay: today,
            focusedDay: today,
            selectedDayPredicate: (day) => isSameDay(day, today),
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            sixWeekMonthsEnforced: false,
            // onDaySelected: (selectedDay, _, __) {
            //   onDaySelected(selectedDay);
            // },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final DateTime normalizedDate =
                    DateTime(date.year, date.month, date.day);
                final bool isToday = isSameDay(today, normalizedDate);
                final bool isPastDay = normalizedDate.isBefore(today);
                final bool? status = state.goalCompletionStatus[normalizedDate];

                if (isToday) {
                  if (status == true) {
                    return const Icon(Icons.check_circle, color: Colors.green);
                  } else {
                    return const Icon(Icons.hourglass_empty,
                        color: Colors.orange);
                  }
                } else if (isPastDay) {
                  if (status == true) {
                    return const Icon(Icons.check_circle, color: Colors.green);
                  } else {
                    return const Icon(Icons.close, color: Colors.red);
                  }
                }

                // Return null for future days
                return null;
              },
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
