import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidgetWeek extends StatefulWidget {
  const CalendarWidgetWeek({super.key});

  @override
  _CalendarViewWidgetState createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarWidgetWeek> {
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
                  child: DayCell(
                    date: date,
                    isSelected: isSameDay(selectedDay, date),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Expanded(
          flex: 15,
          child: FoodMenu(),
        ),
      ],
    );
  }
}

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;

  const DayCell({
    Key? key,
    required this.date,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());
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
            DayText(date: date, isTodayOrSelected: isTodayOrSelected),
            if (isTodayOrSelected) const TodayIndicator(),
          ],
        ),
      ),
    );
  }
}

class DayText extends StatelessWidget {
  final DateTime date;
  final bool isTodayOrSelected;

  const DayText({
    Key? key,
    required this.date,
    required this.isTodayOrSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          DateFormat('EEE').format(date),
          style: TextStyle(
            fontWeight: isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
            color: isTodayOrSelected ? Colors.blue : Colors.grey,
          ),
        ),
        Text(
          DateFormat('d').format(date),
          style: TextStyle(
            fontWeight: isTodayOrSelected ? FontWeight.w900 : FontWeight.w100,
            color: isTodayOrSelected ? Colors.blue : Colors.white,
          ),
        ),
      ],
    );
  }
}

class TodayIndicator extends StatelessWidget {
  const TodayIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}

class FoodMenu extends StatelessWidget {
  const FoodMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Lunch',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Dinner',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
