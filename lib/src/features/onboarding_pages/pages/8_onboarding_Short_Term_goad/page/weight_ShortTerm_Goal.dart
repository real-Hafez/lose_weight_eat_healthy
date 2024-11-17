import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class weight_ShortTerm_Goal extends StatelessWidget {
  const weight_ShortTerm_Goal({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

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
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  String _userGoal = 'Loading...';
  double weightLb = 176;
  double weightKg = 80;
  String weightUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _loadUserGoal();
    _loadUserWeight();
    _setDefaultTargetWeight();
  }

  Future<void> _loadUserGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userGoal = prefs.getString('user_target') ?? 'Lose Weight';
    });
  }

  Future<void> _loadUserWeight() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      weightKg = prefs.getDouble('weightKg') ?? 70;
      weightLb = prefs.getDouble('weightLb') ?? 176;
      weightUnit = prefs.getString('weightUnit') ?? 'kg';
    });
  }

  void updateEndDate() {
    int weeks = 4;
    switch (selectedTimeFrame) {
      case '1 week':
        endDate = DateTime.now().add(const Duration(days: 7));
        weeks = 1;
        break;
      case '2 weeks':
        endDate = DateTime.now().add(const Duration(days: 14));
        weeks = 2;
        break;
      case '1 month':
        endDate = DateTime.now().add(const Duration(days: 30));
        weeks = 4;
        break;
      case '2 months':
        endDate = DateTime.now().add(const Duration(days: 60));
        weeks = 8;
        break;
      case 'Custom':
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ).then((selectedDate) {
          if (selectedDate != null) {
            if (selectedDate.difference(DateTime.now()).inDays < 7) {
              ToastUtil.showToast(
                  'Please select a date at least 1 week from today.');
            } else {
              setState(() {
                endDate = selectedDate;
              });
            }
          }
        });
        return;
    }
    _setDefaultTargetWeight(weeks);
    setState(() {});
  }

  void _setDefaultTargetWeight([int weeks = 4]) {
    double currentWeight = weightUnit == 'kg' ? weightKg : weightLb;
    double weightLossPerWeek = weightUnit == 'kg' ? 1 : 2.2;
    double targetWeight = currentWeight - (weeks * weightLossPerWeek);

    weightController.text = targetWeight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Your Short-Term Weight ${_userGoal.contains('Gain') ? 'Gain' : 'Loss'} Goal',
          style: TextStyle(fontFamily: 'Indie_Flower'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                weightUnit == 'kg' ? weightKg.toString() : weightLb.toString()),
            const Text(
              'I want to achieve my goal in...',
              style: TextStyle(fontSize: 18, fontFamily: 'Indie_Flower'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedTimeFrame,
              items: [
                '1 week',
                '2 weeks',
                '1 month',
                '2 months',
                'Custom',
              ].map((timeFrame) {
                return DropdownMenuItem<String>(
                  value: timeFrame,
                  child: Row(
                    children: [
                      Text(timeFrame),
                      if (timeFrame == '1 month') ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        const Text(
                          'Recommended',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedTimeFrame = value;
                    updateEndDate();
                  });
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
              'And I want on that Date: ${DateFormat('d MMMM yyyy').format(endDate)} to be in',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                    'Target Weight (e.g., ${weightUnit == 'kg' ? '73 kg' : '176 lb'})',
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
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Confirm Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
