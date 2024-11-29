import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/ActivityLevelCard.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/10_onboarding_activity_level/widget/activityLevels.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? selectedCalculation;

  void selectActivityLevel(String title, String calculation) {
    setState(() {
      selectedActivityLevel = title;
      selectedCalculation = calculation;
    });
  }

  Future<void> saveData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null &&
        selectedActivityLevel != null &&
        selectedCalculation != null) {
      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'selectedActivityLevel': selectedActivityLevel,
        'calculation': selectedCalculation,
      }, SetOptions(merge: true));

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedActivityLevel', selectedActivityLevel!);
      await prefs.setString('calculation', selectedCalculation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleWidget(title: '${S().activitylevel}'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activityLevels.length,
                itemBuilder: (context, index) {
                  final level = activityLevels[index];
                  return ActivityLevelCard(
                    title: level["title"]!,
                    description: level["description"]!,
                    calculation: level["calculation"]!,
                    isSelected: selectedActivityLevel == level["title"],
                    onTap: () => selectActivityLevel(
                      level["title"]!,
                      level["calculation"]!,
                    ),
                  );
                },
              ),
            ),
            NextButton(
              onPressed: () async {
                await saveData(); // Save data before navigating
                widget.onNextButtonPressed();
              },
              collectionName: 'Activity level',
              dataToSave: {
                'selectedactivitylevel': selectedActivityLevel,
                'calculation': selectedCalculation,
              },
              saveData: true,
              userId: FirebaseAuth.instance.currentUser?.uid,
            ),
          ],
        ),
      ),
    );
  }
}
