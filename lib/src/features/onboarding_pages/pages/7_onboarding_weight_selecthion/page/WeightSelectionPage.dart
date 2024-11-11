import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/Bmi_card.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/KgPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/LbPicker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/widget/ToggleButtonsWidgetkg.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/localization/LocaleCubit/LocaleCubit.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightSelecthion_Page extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final String heightUnit;

  const WeightSelecthion_Page({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
    required this.heightUnit,
  });

  @override
  State<WeightSelecthion_Page> createState() => _WeightSelecthion_PageState();
}

class _WeightSelecthion_PageState extends State<WeightSelecthion_Page> {
  double _weightKg = 70.0;
  double _weightLb = 154.0;
  String _weightUnit = 'kg';
  double _bmi = 23.4;
  double _heightM = 1.65;

  @override
  void initState() {
    super.initState();
    _weightUnit =
        widget.heightUnit == 'ft' || widget.heightUnit == 'رطل' ? 'lb' : 'kg';
    _initializeValues();
  }

  // Updated function to load both height and weight before updating BMI (like lood the numbers first then update the bmi card )
  Future<void> _initializeValues() async {
    await _loadWeightFromPreferences();
    await _loadHeightFromPreferences();
    _updateBMI();
  }

  Future<void> _loadWeightFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedWeightKg = prefs.getDouble('weightKg') ?? 70.0;
    double savedWeightLb = prefs.getDouble('weightLb') ?? 154.4;

    setState(() {
      if (_weightUnit == 'kg') {
        _weightKg = savedWeightKg;
        _weightLb = _kgToLb(_weightKg);
      } else {
        _weightLb = savedWeightLb;
        _weightKg = _lbToKg(_weightLb);
      }
    });
  }

  Future<void> _loadHeightFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedHeightCm = prefs.getInt('heightCm') ?? 170;

    setState(() {
      _heightM = savedHeightCm / 100;
    });
  }

  double _calculateBMI(double weightKg) {
    return weightKg / (_heightM * _heightM);
  }

  void _updateBMI() {
    setState(() {
      if (_weightUnit == 'kg') {
        _bmi = _calculateBMI(_weightKg);
      } else {
        _bmi = _calculateBMI(_lbToKg(_weightLb));
      }
    });
  }

  void _updateWeightValues() {
    setState(() {
      if (_weightUnit == 'lb') {
        _weightLb = double.parse(_kgToLb(_weightKg).toStringAsFixed(1));
        _weightLb = _weightLb.clamp(66.0, 440.0);
        _weightKg = double.parse(_lbToKg(_weightLb).toStringAsFixed(1));
      } else {
        _weightKg = double.parse(_lbToKg(_weightLb).toStringAsFixed(1));
        _weightKg = _weightKg.clamp(30.0, 165.0);
        _weightLb = double.parse(_kgToLb(_weightKg).toStringAsFixed(1));
      }
    });
  }

  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressIndicatorWidget(value: 0.4),
          const SizedBox(height: 20),
          TitleWidget(title: S().weight),
          const SizedBox(height: 20),
          ToggleButtonsWidgetkg(
            weightUnit: _weightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _weightUnit = unit;
                _updateWeightValues();
                _updateBMI();
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _weightUnit == 'kg'
                  ? KgPicker(
                      weightKg: _weightKg,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightKg = value;
                          _weightLb = _kgToLb(_weightKg);
                          _updateBMI();
                        });
                      },
                    )
                  : LbPicker(
                      weightLb: _weightLb,
                      onWeightChanged: (value) {
                        setState(() {
                          _weightLb = value;
                          _weightKg = _lbToKg(_weightLb);
                          _updateBMI();
                        });
                      },
                    ),
            ),
          ),
          Bmi_Card(bmiValue: _bmi),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .02,
          ),
          NextButton(
            collectionName: 'weight',
            onPressed: widget.onNextButtonPressed,
            dataToSave: {
              'weightKg': _weightKg,
              'weightLb': _weightLb,
              'weightUnit': _weightUnit,
            },
            userId: FirebaseAuth.instance.currentUser?.uid,
          ),
        ],
      ),
    );
  }
}
