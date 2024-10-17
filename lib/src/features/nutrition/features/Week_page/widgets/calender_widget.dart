import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class calender_widget_Week extends StatefulWidget {
  const calender_widget_Week({super.key});

  @override
  _calender_view_widgetState createState() => _calender_view_widgetState();
}

class _calender_view_widgetState extends State<calender_widget_Week> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late List<DateTime> weekDates;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = focusedDay;
    weekDates = _getWeekFromSaturdayToFriday(focusedDay);
  }

  List<DateTime> _getWeekFromSaturdayToFriday(DateTime date) {
    int differenceFromSaturday = date.weekday % 7;
    DateTime saturday = date.subtract(Duration(days: differenceFromSaturday));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar section on the left side (small space)
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: weekDates.map((date) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = date;
                      focusedDay = date;
                    });
                  },
                  child: _buildDayCell(date,
                      isSelected: isSameDay(selectedDay, date)),
                );
              }).toList(),
            ),
          ),
        ),
        // const SizedBox(width: 50), //  space between calendar and food items
        const Expanded(
          flex: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Breakfast',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Lunch',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Dinner',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime date,
      {bool isToday = false, bool isSelected = false}) {
    bool isTodayOrSelected = isToday || isSelected;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    fontWeight:
                        isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
                    color: isTodayOrSelected ? Colors.blue : Colors.grey,
                  ),
                ),
                Text(
                  DateFormat('d').format(date),
                  style: TextStyle(
                    fontWeight:
                        isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
                    color: isTodayOrSelected ? Colors.blue : Colors.white,
                  ),
                ),
              ],
            ),
            if (isTodayOrSelected)
              Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
