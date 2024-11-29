import 'package:flutter/material.dart';

class ActivityLevelDetails extends StatelessWidget {
  final String title;
  final String description;
  final String calculation;
  final bool isSelected;

  const ActivityLevelDetails({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.sizeOf(context).height * .025,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * .007),
        Text(
          description,
          style: TextStyle(
            fontSize: MediaQuery.sizeOf(context).height * .020,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
