import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
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

  // Get the week range from Saturday to Friday based on the current date
  List<DateTime> _getWeekFromSaturdayToFriday(DateTime date) {
    int differenceFromSaturday = date.weekday % 7;
    DateTime saturday = date.subtract(Duration(days: differenceFromSaturday));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
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
          ],
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime date,
      {bool isToday = false, bool isSelected = false}) {
    bool isTodayOrSelected = isToday || isSelected;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .02),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            if (isTodayOrSelected)
              Container(
                width: MediaQuery.of(context).size.width * .04,
                height: MediaQuery.of(context).size.height * .04,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontWeight:
                    isTodayOrSelected ? FontWeight.w900 : FontWeight.w900,
                color: isTodayOrSelected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(
                fontWeight:
                    isTodayOrSelected ? FontWeight.w900 : FontWeight.w900,
                color: isTodayOrSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
