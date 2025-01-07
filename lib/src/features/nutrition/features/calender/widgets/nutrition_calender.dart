import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import FlutterToast for showing messages

class Nutrition_Calendar extends StatefulWidget {
  const Nutrition_Calendar({super.key});

  @override
  State<Nutrition_Calendar> createState() => _Nutrition_CalendarState();
}

class _Nutrition_CalendarState extends State<Nutrition_Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // Determine the current locale
    String currentLocale = Localizations.localeOf(context).languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        locale: currentLocale == 'ar'
            ? 'ar'
            : 'en', // Set locale to 'ar' for Arabic, 'en' for English
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Week',
        },
        startingDayOfWeek:
            StartingDayOfWeek.saturday, // Week starts on Saturday
        headerVisible: false,
        pageJumpingEnabled: false, // Prevents jumping across pages
        pageAnimationEnabled: false, // Disables any scrolling animations

        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          // Calculate the start of the week (Saturday)
          DateTime startOfWeek = _focusedDay.subtract(
            Duration(
                days: _focusedDay.weekday == 7 ? 0 : _focusedDay.weekday + 1),
          ); // Saturday

          DateTime endOfWeek =
              startOfWeek.add(const Duration(days: 6)); // Friday

          if (selectedDay.isBefore(startOfWeek) ||
              selectedDay.isAfter(endOfWeek)) {
            // Show message and reset selection
            Fluttertoast.showToast(
              msg: "${S().thisweek}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            setState(() {
              _selectedDay = null; // Reset selected day
              _focusedDay = DateTime.now(); // Reset focused day to today
            });
          } else {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // Set to keep the current focused day
            });
          }
        },

        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2), // Subtle orange for today
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange, width: 2),
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.teal, // Teal for selected day
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white, // White text for selected day
            fontWeight: FontWeight.bold,
          ),
          defaultDecoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(
            color: Colors.grey, // Light grey for unselected days
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.grey, // Slightly darker grey for weekends
          ),
          cellMargin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: currentLocale == 'ar'
                ? Colors.grey
                : Colors.black, // Arabic: grey, English: black
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: currentLocale == 'ar'
                ? Colors.grey
                : Colors.black, // Arabic: grey, English: black
            fontSize: 12,
          ),
        ),

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            // Convert the day number to Arabic numerals if locale is Arabic
            String dayText = currentLocale == 'ar'
                ? NumberConversionHelper.convertToArabicNumbers(
                    day.day.toString())
                : day.day.toString();

            return Center(
              child: Text(
                dayText, // Display the appropriate numeral
                style: TextStyle(
                    color: currentLocale == 'ar' ? Colors.grey : Colors.black),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            // Convert today's date to Arabic numerals if locale is Arabic
            String arabicToday = currentLocale == 'ar'
                ? NumberConversionHelper.convertToArabicNumbers(
                    day.day.toString())
                : day.day.toString();

            return Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Center(
                child: Text(
                  arabicToday, // Display today's date in appropriate locale
                  style: const TextStyle(color: Colors.orange),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
