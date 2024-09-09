import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/sixthOnboardingPage.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ToggleButtonsWidgetkg.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class WeightSelectionPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final String heightUnit;

  const WeightSelectionPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
    required this.heightUnit,
  });

  @override
  State<WeightSelectionPage> createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  double _weightKg = 70.0; // Default weight in kg
  double _weightLb = 154.0; // Default weight in pounds
  String _weightUnit = 'kg'; // Default weight unit

  @override
  void initState() {
    super.initState();
    // Set default values based on heightUnit
    _weightUnit = widget.heightUnit == 'ft' ? 'lb' : 'kg';
    _updateWeightValues(); // Ensure values are updated based on the initial unit
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressIndicatorWidget(value: 0.4),
          const SizedBox(height: 20),
          const TitleWidget(title: 'What\'s your weight?'),
          const SizedBox(height: 20),
          ToggleButtonsWidgetkg(
            weightUnit: _weightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _weightUnit = unit;
                _updateWeightValues();
              });
            },
          ),
          const SizedBox(height: 20),
          // WeightLossMessageWidget(
          //   currentWeight: _weightKg,
          //   targetWeight: _weightLb,
          //   weightUnit: _weightUnit,
          // ),
          Expanded(
            child: Center(
              child: _weightUnit == 'kg'
                  ? KgPicker(
                      weightKg: _weightKg,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightKg = value;
                          _weightLb = _kgToLb(_weightKg);
                        });
                      },
                    )
                  : LbPicker(
                      weightLb: _weightLb,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightLb = value;
                          _weightKg = _lbToKg(_weightLb);
                        });
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          NextButton(
            collectionName: 'weight',
            onPressed: widget.onNextButtonPressed,
            dataToSave: {
              'weightKg': _weightKg,
              'weightLb': _weightLb,
              'weightUnit': _weightUnit,
              // Include other data as necessary
            },
            userId: FirebaseAuth.instance.currentUser?.uid,
          ),
        ],
      ),
    );
  }

  void _updateWeightValues() {
    if (_weightUnit == 'lb') {
      // Convert kg to pounds and round to 1 decimal place
      _weightLb = double.parse(_kgToLb(_weightKg).toStringAsFixed(1));
      // Ensure values are within valid range
      if (_weightLb < 66) _weightLb = 66.0;
      if (_weightLb > 440) _weightLb = 440.0;
      _weightKg = double.parse(_lbToKg(_weightLb).toStringAsFixed(1));
    } else {
      // Convert pounds to kg and round to 1 decimal place
      _weightKg = double.parse(_lbToKg(_weightLb).toStringAsFixed(1));
      // Ensure values are within valid range
      if (_weightKg < 30) _weightKg = 30.0;
      if (_weightKg > 165) _weightKg = 165.0;
      _weightLb = double.parse(_kgToLb(_weightKg).toStringAsFixed(1));
    }
  }

  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;
}
