import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/utils/helper/height_conversion.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/cm_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ft_inches_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/height_display_widget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/toggle_buttons_widget.dart.dart';

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
          ProgressIndicatorWidget(value: 0.2),
          const SizedBox(height: 20),
          TitleWidget(title: S().heigh),
          const SizedBox(height: 20),
          ToggleButtonsWidget(
            heightUnit: _heightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _heightUnit = unit;
                _updateHeightValues();
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
                          _updateHeightValues();
                        });
                      },
                    )
                  : FtInchesPicker(
                      heightFt: _heightFt,
                      heightInches: _heightInches,
                      onFtChanged: (value) {
                        setState(() {
                          _heightFt = value;
                          _updateHeightValues();
                        });
                      },
                      onInchesChanged: (value) {
                        setState(() {
                          _heightInches = value;
                          _updateHeightValues();
                        });
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          NextButton(
            collectionName: 'height',
            onPressed: widget.onNextButtonPressed,
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

  void _updateHeightValues() {
    if (_heightUnit == 'ft') {
      int cmValue = convertFtInchesToCm(_heightFt, _heightInches);
      if (cmValue < 95) cmValue = 95;
      if (cmValue > 241) cmValue = 241;

      setState(() {
        _heightCm = cmValue;
      });
    } else {
      convertCmToFtInches(_heightCm, (feet, inches) {
        if (feet < 3) feet = 3;
        if (feet > 7) feet = 7;
        if (inches < 0) inches = 0;
        if (inches > 11) inches = 11;

        setState(() {
          _heightFt = feet;
          _heightInches = inches;
        });
      });
    }
  }
}
