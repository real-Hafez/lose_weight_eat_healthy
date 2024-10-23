import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class HowQuickYouWantToLoseWeight extends StatefulWidget {
  const HowQuickYouWantToLoseWeight(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<HowQuickYouWantToLoseWeight> createState() =>
      _HowQuickYouWantToLoseWeightState();
}

class _HowQuickYouWantToLoseWeightState
    extends State<HowQuickYouWantToLoseWeight> {
  // A value to store the weight-loss goal
  double currentValue = 0;

  // Variable to keep track of selected card
  String selectedGoal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              context,
              'Lose 1 kg per week',
              Icons.directions_run,
              FontAwesomeIcons.weightScale,
              FontAwesomeIcons.appleWhole,
              selectedGoal == 'Lose 1 kg per week',
              () {
                setState(() {
                  currentValue = 1; // Set to 1 kg per week
                  selectedGoal = 'Lose 1 kg per week'; // Update selected goal
                });
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              'Lose 0.5 kg per week',
              Icons.favorite_border,
              FontAwesomeIcons.dumbbell,
              FontAwesomeIcons.heartbeat,
              selectedGoal == 'Lose 0.5 kg per week',
              () {
                setState(() {
                  currentValue = 0.5; // Set to 0.5 kg per week
                  selectedGoal = 'Lose 0.5 kg per week'; // Update selected goal
                });
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              'Maintain weight',
              Icons.balance,
              FontAwesomeIcons.balanceScale,
              FontAwesomeIcons.leaf,
              selectedGoal == 'Maintain weight',
              () {
                setState(() {
                  currentValue = 0; // Set to maintain weight
                  selectedGoal = 'Maintain weight'; // Update selected goal
                });
              },
            ),
            const Spacer(),

            // Show the NextButton only if a goal is selected
            if (selectedGoal.isNotEmpty)
              NextButton(
                saveData: true,
                onPressed: () {
                  // Save data and navigate to the next screen
                  _saveDataAndNavigate(selectedGoal);
                },
                collectionName:
                    'HowMuchLosing_weight_per_week', // Adjust collection name as needed
                dataToSave: {
                  'HowMuchLoseWeight': currentValue.toStringAsFixed(1),
                  'Goal': selectedGoal,
                },
                userId: FirebaseAuth.instance.currentUser?.uid,
              ),
          ],
        ),
      ),
    );
  }

  // A method to save the data and navigate to the next screen
  void _saveDataAndNavigate(String goal) {
    // Navigate to the next screen
    widget.onNextButtonPressed(); // Trigger the next step animation
  }

  // A helper method to build the cards with icons
  Widget _buildCard(
    BuildContext context,
    String title,
    IconData mainIcon,
    IconData icon1,
    IconData icon2,
    bool isSelected, // Check if the card is selected
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: isSelected
            ? Colors.blueAccent.withOpacity(0.2)
            : Colors.white, // Change color if selected
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(mainIcon, size: 40, color: Colors.blueAccent),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(icon1, size: 20, color: Colors.orange),
                      const SizedBox(width: 10),
                      Icon(icon2, size: 20, color: Colors.green),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
