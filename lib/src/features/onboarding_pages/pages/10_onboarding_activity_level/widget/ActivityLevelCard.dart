import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/ActivityLevelDetails.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/activityLevels.dart';

class ActivityLevelCard extends StatelessWidget {
  final String title;
  final String description;
  final double calculation;

  final bool isSelected;

  final VoidCallback onTap;

  const ActivityLevelCard({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle,
                color: isSelected ? Colors.blue : Colors.grey,
                size: MediaQuery.sizeOf(context).height * .04,
              ),
              SizedBox(width: MediaQuery.sizeOf(context).height * .02),
              Expanded(
                child: ActivityLevelDetails(
                  title: title,
                  description: description,
                  calculation: calculation,
                  isSelected: isSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
