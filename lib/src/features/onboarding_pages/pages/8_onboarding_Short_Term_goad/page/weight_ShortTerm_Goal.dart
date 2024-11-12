import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/features/home/widgets/streak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class weight_ShortTerm_Goal extends StatelessWidget {
  const weight_ShortTerm_Goal(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return WeightGoalPage();
  }
}

class WeightGoalPage extends StatefulWidget {
  @override
  _WeightGoalPageState createState() => _WeightGoalPageState();
}

class _WeightGoalPageState extends State<WeightGoalPage> {
  String selectedTimeFrame = '1 month';
  TextEditingController weightController = TextEditingController();
  DateTime endDate =
      DateTime.now().add(const Duration(days: 30)); // Default for '1 month'

  String _userGoal = 'Loading...'; // Initial placeholder
  double weightLb = 176;
  double weightKg = 80;
  String weight_unit = 'kg';

  @override
  void initState() {
    super.initState();
    _loadUserGoal();
    _loadUserweight();
  }

  Future<void> _loadUserGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the saved user goal or use a default if not found
      _userGoal = prefs.getString('user_target') ?? 'Lose Weight';
    });
  }

  Future<void> _loadUserweight() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the saved user weight or use a default if not found
      weightKg = prefs.getDouble('weightKg') ?? 70;
      weightLb = prefs.getDouble(
            'weightLb',
          ) ??
          176;

      weight_unit = prefs.getString(
            'weightUnit',
          ) ??
          'kg';
    });
  }

  void updateEndDate() {
    switch (selectedTimeFrame) {
      case '1 week':
        endDate = DateTime.now().add(const Duration(days: 7));
        break;
      case '2 weeks':
        endDate = DateTime.now().add(const Duration(days: 14));
        break;
      case '1 month':
        endDate = DateTime.now().add(const Duration(days: 30));
        break;
      case '2 months':
        endDate = DateTime.now().add(const Duration(days: 60));
        break;
      case 'Custom':
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ).then((selectedDate) {
          if (selectedDate != null) {
            setState(() {
              endDate = selectedDate;
            });
          }
        });
        return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Short-Term Weight Goal',
            style: TextStyle(fontFamily: 'Indie_Flower')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(weightLb.toString()),
            Text(
              'I want to achieve my goal in...',
              style: TextStyle(fontSize: 18, fontFamily: 'Indie_Flower'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedTimeFrame,
              items: ['1 week', '2 weeks', '1 month', '2 months', 'Custom']
                  .map((timeFrame) => DropdownMenuItem(
                        value: timeFrame,
                        child: Text(timeFrame),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedTimeFrame = value;
                  updateEndDate();
                }
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'And i want in that Date : ${DateFormat('d MMMM yyyy').format(endDate)} to be in',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Weight (e.g., 73 kg)',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle goal submission
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
              ),
              child: const Text('Confirm Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
