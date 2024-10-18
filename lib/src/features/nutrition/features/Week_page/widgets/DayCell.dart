import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const DayCell({
    Key? key,
    required this.date,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isToday = isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isExpanded ? 250 : 100,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE').format(date),
                style: TextStyle(
                  fontWeight: isToday || isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isToday || isSelected ? Colors.blue : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isToday || isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isToday || isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
