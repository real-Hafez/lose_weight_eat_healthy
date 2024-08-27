import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/utils/helper/height_conversion.dart';
import 'package:numberpicker/numberpicker.dart';

class SecondOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;

  const SecondOnboardingPage({
    super.key,
    required this.onAnimationFinished,
  });

  @override
  State<SecondOnboardingPage> createState() => _SecondOnboardingPageState();
}

class _SecondOnboardingPageState extends State<SecondOnboardingPage> {
  int _heightCm = 165; // Default height in cm
  int _heightFt = 5; // Default height in feet
  int _heightInches = 1; // Default height in inches
  String _heightUnit = 'cm'; // Default height unit

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
            minHeight: 4,
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "What's your height?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ToggleButtons(
              isSelected: [_heightUnit == 'cm', _heightUnit == 'ft'],
              onPressed: (int index) {
                setState(() {
                  _heightUnit = index == 0 ? 'cm' : 'ft';
                  _updateHeightValues();
                });
              },
              borderColor: Colors.grey,
              selectedBorderColor: Colors.green,
              selectedColor: Colors.white,
              fillColor: Colors.green,
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('cm'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('ft'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _heightUnit == 'cm'
                  ? '$_heightCm cm'
                  : '$_heightFt\'$_heightInches"',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _heightUnit == 'cm'
                  ? _buildCmPicker()
                  : _buildFtInchesPicker(),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle next button press
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _updateHeightValues() {
    if (_heightUnit == 'ft') {
      convertCmToFtInches(_heightCm, (feet, inches) {
        setState(() {
          _heightFt = feet;
          _heightInches = inches;
        });
      });
    } else {
      _heightCm = convertFtInchesToCm(_heightFt, _heightInches);
    }
  }

  Widget _buildCmPicker() {
    return NumberPicker(
      value: _heightCm,
      minValue: 100,
      maxValue: 241,
      onChanged: (value) => setState(() => _heightCm = value),
      textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
      selectedTextStyle:
          const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFtInchesPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: _heightFt,
          minValue: 3,
          maxValue: 7,
          onChanged: (value) => setState(() => _heightFt = value),
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        NumberPicker(
          value: _heightInches,
          minValue: 0,
          maxValue: 11,
          onChanged: (value) => setState(() => _heightInches = value),
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          selectedTextStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
