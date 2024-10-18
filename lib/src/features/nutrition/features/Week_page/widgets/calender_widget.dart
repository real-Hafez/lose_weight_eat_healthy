import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/widgets/DayCell.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Week_page/widgets/MealRow.dart';

class CalendarWidgetWeek extends StatefulWidget {
  const CalendarWidgetWeek({Key? key}) : super(key: key);

  @override
  _CalendarWidgetWeekState createState() => _CalendarWidgetWeekState();
}

class _CalendarWidgetWeekState extends State<CalendarWidgetWeek> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late List<DateTime> weekDates;
  late DateTime? expandedDay;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now(); // Set initial focused day to today
    selectedDay = focusedDay; // Default selected day is today
    expandedDay = selectedDay; // Initially expand  by def
    weekDates = _getWeekFromSaturdayToFriday(focusedDay); // Get the week dates
  }

  // Get week range from Saturday to Friday for the given date
  List<DateTime> _getWeekFromSaturdayToFriday(DateTime date) {
    int differenceFromSaturday = date.weekday % 7;
    DateTime saturday = date.subtract(Duration(days: differenceFromSaturday));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  // Toggle between expanding and collapsing a day's meal details
  void _toggleExpanded(DateTime date) {
    setState(() {
      expandedDay =
          expandedDay == date ? null : date; // Collapse if already expanded
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with meal types
                Row(
                  children: [
                    const SizedBox(
                        width:
                            80), // Empty space for the day cells for brekfast etc..
                    Expanded(
                        child: Center(child: _buildHeaderText('Breakfast'))),
                    const VerticalDivider(),
                    Expanded(child: Center(child: _buildHeaderText('Lunch'))),
                    const VerticalDivider(),
                    Expanded(child: Center(child: _buildHeaderText('Dinner'))),
                  ],
                ),
                const SizedBox(height: 6),
                // Main content: Day cells and meal rows
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day cells on the left
                    SizedBox(
                      width: 80,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: weekDates.length, // Total days in the week
                        itemBuilder: (context, index) {
                          final date = weekDates[index];
                          final bool isExpanded = expandedDay == date;
                          return DayCell(
                            date: date,
                            isSelected: isSameDay(selectedDay, date),
                            isExpanded: isExpanded, // Show expanded view
                            onTap: () {
                              setState(() {
                                selectedDay = date; // Update selected day
                                _toggleExpanded(date);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Space between day cells and meal rows
                    // Meal rows on the right
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: weekDates.length,
                        itemBuilder: (context, index) {
                          final date = weekDates[index];
                          return MealRow(
                            date: date,
                            isExpanded: expandedDay ==
                                date, // Check if this date is expanded
                            onTapExpand: () =>
                                _toggleExpanded(date), // Handle tap to expand
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build header text for meals
  static Widget _buildHeaderText(String text) {
    return AutoSizeText(
      text,
      maxLines: 1,
      maxFontSize: 22,
      minFontSize: 12,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Helper function to compare two dates and see if they are the same day
bool isSameDay(DateTime day1, DateTime day2) {
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}
