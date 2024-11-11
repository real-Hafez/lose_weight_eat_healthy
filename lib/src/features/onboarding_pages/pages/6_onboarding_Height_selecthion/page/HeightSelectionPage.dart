import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/utils/helper/height_conversion.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/6_onboarding_Height_selecthion/widget/cm_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/6_onboarding_Height_selecthion/widget/ft_inches_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/6_onboarding_Height_selecthion/widget/height_display_widget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/6_onboarding_Height_selecthion/widget/HeightUnit_Selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeightSelectionPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final Function(String) onHeightUnitChanged;

  const HeightSelectionPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
    required this.onHeightUnitChanged,
  });

  @override
  State<HeightSelectionPage> createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  static const int minCmValue = 95;
  static const int maxCmValue = 241;
  static const int minFt = 3;
  static const int maxFt = 7;
  static const int minInches = 0;
  static const int maxInches = 11;

  int _heightCm = 165;
  int _heightFt = 5;
  int _heightInches = 1;
  String _heightUnit = 'cm';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressIndicatorWidget(value: 0.3),
          const SizedBox(height: 20),
          TitleWidget(title: S().heigh),
          const SizedBox(height: 20),
          HeightUnitSelector(
            heightUnit: _heightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _heightUnit = unit;
                syncHeightUnits();
                widget.onHeightUnitChanged(unit);
              });
            },
          ),
          const SizedBox(height: 20),
          HeightDisplayWidget(
            heightCm: _heightCm,
            heightFt: _heightFt,
            heightInches: _heightInches,
            heightUnit: _heightUnit,
          ),
          Expanded(
            child: Center(
              child: _heightUnit == 'cm'
                  ? CmPicker(
                      heightCm: _heightCm,
                      onHeightChanged: (value) {
                        setState(() {
                          _heightCm = value;
                          syncHeightUnits();
                        });
                      },
                    )
                  : FtInchesPicker(
                      heightFt: _heightFt,
                      heightInches: _heightInches,
                      onFtChanged: (value) {
                        setState(() {
                          _heightFt = value;
                          syncHeightUnits();
                        });
                      },
                      onInchesChanged: (value) {
                        setState(() {
                          _heightInches = value;
                          syncHeightUnits();
                        });
                      },
                    ),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * .01),
          NextButton(
            collectionName: 'height',
            onPressed: () async {
              // Save data to SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();

              // Saving height in centimeters in shared pre
              await prefs.setInt('heightCm', _heightCm);

              // Saving height in feet and inches as a formatted string
              String ftInches = '$_heightFt\'${_heightInches}\'';
              await prefs.setString('heightFtInches', ftInches);

              widget.onNextButtonPressed();
            },
            userId: FirebaseAuth.instance.currentUser?.uid,
            dataToSave: {
              'heightCm': _heightCm,
              'heightFt': _heightFt,
              'heightInches': _heightInches,
              'heightUnit': _heightUnit,
            },
            saveData: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void syncHeightUnits() {
    if (_heightUnit == 'ft') {
      _heightCm = _constrainValue(
        convertFtInchesToCm(_heightFt, _heightInches),
        minCmValue,
        maxCmValue,
      );
    } else {
      convertCmToFtInches(_heightCm, (feet, inches) {
        _heightFt = _constrainValue(feet, minFt, maxFt);
        _heightInches = _constrainValue(inches, minInches, maxInches);
      });
    }
  }

  int _constrainValue(int value, int minValue, int maxValue) {
    return value.clamp(minValue, maxValue);
  }
}
