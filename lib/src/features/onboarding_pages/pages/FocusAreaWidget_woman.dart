import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';

class FocusAreaWidget_woman extends StatefulWidget {
  const FocusAreaWidget_woman({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
    required this.onSelectionMade,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final Function(List<String>) onSelectionMade;

  @override
  State<FocusAreaWidget_woman> createState() => _FocusAreaWidget_womanState();
}

class _FocusAreaWidget_womanState extends State<FocusAreaWidget_woman> {
  List<bool> isSelectedList = [false, false, false, false];
  List<String> selectedOptions = [];

  void toggleSelection(int index) {
    setState(() {
      isSelectedList[index] = !isSelectedList[index];
      selectedOptions = _getSelectedOptions();
      widget.onSelectionMade(selectedOptions); // Pass selections back
    });
  }

  List<String> _getSelectedOptions() {
    List<String> options = [];
    for (int i = 0; i < isSelectedList.length; i++) {
      if (isSelectedList[i]) {
        options.add(_getSelectionName(i));
      }
    }
    return options;
  }

  String _getSelectionName(int index) {
    switch (index) {
      case 0:
        return 'weigh lose';
      case 1:
        return 'body shaping';
      case 2:
        return 'Nutrition';
      case 3:
        return 'water reminder';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('what\'s your goal'),
        const SizedBox(height: 10),
        WeightLossWidget(
          subtext: 'I\'m overweight and want to focus on losing weight.',
          icon: Icons.scale,
          text: 'Weight and Fat Loss',
          isSelected: isSelectedList[0],
          onTap: () => toggleSelection(0),
        ),
        WeightLossWidget(
          icon: Icons.fitness_center,
          text: 'Body Shaping',
          subtext:
              'I want to develop an athletic body and increase muscle mass.',
          isSelected: isSelectedList[1],
          onTap: () => toggleSelection(1),
        ),
        WeightLossWidget(
          icon: Icons
              .apple, // Example icon; use an appropriate icon for Nutrition
          text: 'Nutrition Advice',
          subtext:
              'Get personalized nutrition tips to support your weight loss goals.',
          isSelected: isSelectedList[2],
          onTap: () => toggleSelection(2),
        ),
        WeightLossWidget(
          icon: Icons.local_drink, // Better icon for water reminder
          text: 'Water Reminder',
          subtext: 'I need reminders about how much water I should drink.',
          isSelected: isSelectedList[3], // Updated index
          onTap: () => toggleSelection(3), // Updated index
        ),
        NextButton(
          onPressed: () {
            widget.onNextButtonPressed();
          },
          dataToSave: {
            'selectedOptions': selectedOptions,
          },
          collectionName: 'userSelections',
          userId: FirebaseAuth.instance.currentUser?.uid,
        ),
      ],
    );
  }
}

class WeightLossWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;
  final String subtext;
  final IconData icon;

  const WeightLossWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.text,
    required this.subtext,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.pink : Colors.grey,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items at the start
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                // Use Flexible to handle unbounded constraints
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height: 4), // Space between main text and subtext
                    Text(
                      subtext,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      maxLines:
                          null, // Allow the text to wrap to multiple lines
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
