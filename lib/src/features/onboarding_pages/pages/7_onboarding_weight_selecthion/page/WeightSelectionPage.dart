import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
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
          Bmi_card(bmiValue: _bmi),
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

class Bmi_card extends StatelessWidget {
  final double bmiValue;
  const Bmi_card({super.key, required this.bmiValue});

  @override
  Widget build(BuildContext context) {
    String bmiStatus = "Normal weight";
    String recommendation =
        "Keep up the good work and maintain a healthy lifestyle!";
    Color statusColor = Colors.green;

    // Check if Arabic is selected to determine number formatting
    final bool isArabic =
        context.read<LocaleCubit>().state.languageCode == 'ar';

    if (bmiValue < 16) {
      bmiStatus = "Severe Thinness";
      recommendation =
          "A healthier you is within reach! Consider consulting a healthcare professional, and explore our app's nutrition plans to support your journey.";
      statusColor = Colors.purple;
    } else if (bmiValue >= 16 && bmiValue < 17) {
      bmiStatus = "Moderate Thinness";
      recommendation =
          "A balanced diet can make a world of difference. Our nutrition plans are here to help you reach your ideal weight.";
      statusColor = Colors.orange;
    } else if (bmiValue >= 17 && bmiValue < 18.5) {
      bmiStatus = "Mild Thinness";
      recommendation =
          "Small changes can lead to great results! Try our healthy meal options to get closer to your wellness goals.";
      statusColor = Colors.yellow;
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      bmiStatus = "Normal";
      recommendation =
          "You’re on the right track! Keep up the great habits and explore new ways to maintain a balanced lifestyle.";
      statusColor = Colors.green;
    } else if (bmiValue >= 25 && bmiValue < 30) {
      bmiStatus = "Overweight";
      recommendation =
          "You're closer to a healthier weight than you think! A nutritious diet and regular exercise can make a big difference. Let’s start together!";
      statusColor = Colors.orangeAccent;
    } else if (bmiValue >= 30 && bmiValue < 35) {
      bmiStatus = "Obese Class I";
      recommendation =
          "With dedication and the right choices, a healthier weight is achievable. Explore our meal plans and workouts tailored to support your journey.";
      statusColor = Colors.redAccent;
    } else if (bmiValue >= 35 && bmiValue < 40) {
      bmiStatus = "Obese Class II";
      recommendation =
          "Your health is a priority. Our app can guide you with personalized nutrition and activity plans to get closer to your goal.";
      statusColor = Colors.red;
    } else if (bmiValue >= 40) {
      bmiStatus = "Obese Class III";
      recommendation =
          "Together, we can make a difference in your health. Consult a healthcare provider and start with our nutrition and wellness options for a fresh start.";
      statusColor = Colors.deepOrange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your BMI",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue[500]!, Colors.blue[300]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isArabic
                          ? NumberConversionHelper.convertToArabicNumbers(
                              bmiValue.toStringAsFixed(1))
                          : bmiValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      bmiStatus,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      recommendation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
