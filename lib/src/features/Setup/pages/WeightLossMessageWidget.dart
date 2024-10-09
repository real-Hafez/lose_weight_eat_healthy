import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ToggleButtonsWidgetkg.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/WeightDisplayWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/WeightLosstarget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class WeightLossMessageWidget extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const WeightLossMessageWidget({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<WeightLossMessageWidget> createState() =>
      _WeightLossMessageWidgetState();
}

class _WeightLossMessageWidgetState extends State<WeightLossMessageWidget> {
  double _weightLossKg = 0.0;
  double _weightLossLb = 0.0;
  double _currentWeightKg = 0.0;
  String _weightUnit = 'kg';

  final double _minWeightLossKg = 5.0;
  final double _minWeightLossLb = 11.0;

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
        _currentWeightKg = userWeightKg;

        if (_weightUnit == 'kg') {
          _weightLossKg = (userWeightKg - _minWeightLossKg)
              .clamp(_minWeightLossKg, userWeightKg);
          _weightLossLb = _kgToLb(_weightLossKg);
        } else {
          _weightLossLb = (_kgToLb(userWeightKg) - _minWeightLossLb)
              .clamp(_minWeightLossLb, _kgToLb(userWeightKg));
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
          ProgressIndicatorWidget(value: 0.5),
          const SizedBox(height: 20),
          TitleWidget(title: S().WeightLoss),
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
          WeightLosstarget(
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
