import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ToggleButtonsWidgetkg.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/WeightDisplayWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class WeightLossMessageWidget extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final String weightUnit;

  const WeightLossMessageWidget({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.weightUnit,
  });

  @override
  Widget build(BuildContext context) {
    final weightDifference = currentWeight - targetWeight;
    final weightLost = weightDifference.toStringAsFixed(1);
    final isGain = weightDifference < 0;
    final displayWeight = isGain ? 'gain' : 'lose';
    final timeEstimate = _estimateTime(weightDifference);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You are going to $displayWeight $weightLost $weightUnit',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isGain
                    ? Colors.red
                    : Colors.green, // Red for gain, green for loss
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'This will take approximately $timeEstimate',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isGain ? Colors.red : Colors.green,
              ),
        ),
      ],
    );
  }

  String _estimateTime(double weightDifference) {
    // Calculate time based on a range of 0.7 to 1.2 kg per week
    const double minRatePerWeek = 0.7;
    const double maxRatePerWeek = 1.2;

    final weeksMin = weightDifference / maxRatePerWeek;
    final weeksMax = weightDifference / minRatePerWeek;

    // Convert weeks to days
    final minDays = (weeksMin * 7).isNaN || (weeksMin * 7).isInfinite
        ? 0
        : (weeksMin * 7).toStringAsFixed(0);
    final maxDays = (weeksMax * 7).isNaN || (weeksMax * 7).isInfinite
        ? 0
        : (weeksMax * 7).toStringAsFixed(0);

    return weightDifference > 0
        ? '$minDays to $maxDays days'
        : '0 days'; // Adjust for weight gain or insufficient weight loss
  }
}

class SixthOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const SixthOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<SixthOnboardingPage> createState() => _SixthOnboardingPageState();
}

class _SixthOnboardingPageState extends State<SixthOnboardingPage> {
  double _weightLossKg = 0.0;
  double _weightLossLb = 0.0;
  double _currentWeightKg = 0.0; // Add this to store the current weight
  String _weightUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _fetchAndSetWeight();
  }

  Future<void> _fetchAndSetWeight() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('data')
          .get();
      final double userWeightKg = doc['weightKg'] ?? 0.0;
      final String userWeightUnit = doc['weightUnit'] ?? 'kg';

      setState(() {
        _weightUnit = userWeightUnit;
        _currentWeightKg = userWeightKg; // Store the current weight

        if (_weightUnit == 'kg') {
          _weightLossKg = userWeightKg - 5.0;
          _weightLossKg = _weightLossKg < 10 ? 10 : _weightLossKg;
          _weightLossLb = _kgToLb(_weightLossKg);
        } else {
          _weightLossLb = _kgToLb(userWeightKg) - _kgToLb(5.0);
          _weightLossLb = _weightLossLb < 22 ? 22 : _weightLossLb;
          _weightLossKg = _lbToKg(_weightLossLb);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressIndicatorWidget(value: 0.8),
          const SizedBox(height: 20),
          const TitleWidget(title: 'How much weight do you want to lose?'),
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
          WeightDisplayWidget(
            weightKg: _weightLossKg,
            weightLb: _weightLossLb,
            weightUnit: _weightUnit,
          ),
          const SizedBox(height: 20),
          WeightLossMessageWidget(
            currentWeight: _currentWeightKg,
            targetWeight: _weightLossKg,
            weightUnit: _weightUnit,
          ),
          Expanded(
            child: Center(
              child: _weightUnit == 'kg'
                  ? KgPicker(
                      weightKg: _weightLossKg,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightLossKg = value;
                          _weightLossLb = _kgToLb(_weightLossKg);
                        });
                      },
                    )
                  : LbPicker(
                      weightLb: _weightLossLb,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightLossLb = value;
                          _weightLossKg = _lbToKg(_weightLossLb);
                        });
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          NextButton(
            collectionName: 'weight_loss',
            onPressed: widget.onNextButtonPressed,
            dataToSave: {
              'weightLossKg': _weightLossKg,
              'weightLossLb': _weightLossLb,
              'weightUnit': _weightUnit,
            },
            userId: FirebaseAuth.instance.currentUser?.uid,
          )
        ],
      ),
    );
  }

  void _updateWeightValues() {
    if (_weightUnit == 'lb') {
      _weightLossLb = double.parse(_kgToLb(_weightLossKg).toStringAsFixed(1));
    } else {
      _weightLossKg = double.parse(_lbToKg(_weightLossLb).toStringAsFixed(1));
    }
  }

  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;
}
