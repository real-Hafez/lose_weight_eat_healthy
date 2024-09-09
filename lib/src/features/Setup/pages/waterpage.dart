import 'package:flutter/material.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _WaterPageState createState() => _WaterPageState();
}

final List<String> _units = ['mL', 'L', 'US oz'];

class _WaterPageState extends State<WaterPage> {
  String _selectedUnit = 'mL'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Reminder'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Select unit:'),
              const SizedBox(width: 16),
              ToggleButtons(
                isSelected:
                    _units.map((unit) => unit == _selectedUnit).toList(),
                onPressed: (int index) {
                  setState(() {
                    _selectedUnit = _units[index];
                  });
                },
                children: _units
                    .map((unit) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(unit),
                        ))
                    .toList(),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
