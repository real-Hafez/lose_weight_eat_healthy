import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/ActivityLevelCard.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/activityLevels.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';

class ActivityLevelPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const ActivityLevelPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  _ActivityLevelPageState createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends State<ActivityLevelPage> {
  String? selectedActivityLevel;

  void selectActivityLevel(String title) {
    setState(() {
      selectedActivityLevel = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitleWidget(title: 'What is your activity level?'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activityLevels.length,
                itemBuilder: (context, index) {
                  final level = activityLevels[index];
                  return ActivityLevelCard(
                    title: level["title"]!,
                    description: level["description"]!,
                    isSelected: selectedActivityLevel == level["title"],
                    onTap: () => selectActivityLevel(level["title"]!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
