import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class Mainuseforapp extends StatefulWidget {
  const Mainuseforapp(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed,
      required this.onSelectionMade});

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final Function(List<String>)
      onSelectionMade; // Pass the selections to the parent

  @override
  State<Mainuseforapp> createState() => _MainuseforappState();
}

class _MainuseforappState extends State<Mainuseforapp> {
  List<bool> isSelectedList = [false, false, false];
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
        return 'Training';
      case 1:
        return 'Water Reminder';
      case 2:
        return 'Nutrition';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Why use this app'),
        const SizedBox(height: 10),
        WeightLossWidget(
          icon: Icons.sports_gymnastics,
          text: 'Weight Loss',
          isSelected: isSelectedList[0],
          onTap: () => toggleSelection(0),
        ),
        WeightLossWidget(
          icon: Icons.water_drop_rounded,
          text: 'Water Reminder',
          isSelected: isSelectedList[1],
          onTap: () => toggleSelection(1),
        ),
        WeightLossWidget(
          icon: Icons.food_bank,
          text: 'Nutrition',
          isSelected: isSelectedList[2],
          onTap: () => toggleSelection(2),
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
  final IconData icon;
  const WeightLossWidget(
      {super.key,
      required this.isSelected,
      required this.onTap,
      required this.text,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.pink
                : Colors.grey, // Change color when selected
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white), // Placeholder icon
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
