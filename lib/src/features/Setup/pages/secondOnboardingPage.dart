import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/utils/helper/height_conversion.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/TitleWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/cm_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/ft_inches_picker.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/height_display_widget.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/toggle_buttons_widget.dart.dart';

class SecondOnboardingPage extends StatefulWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  const SecondOnboardingPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  @override
  State<SecondOnboardingPage> createState() => _SecondOnboardingPageState();
}

class _SecondOnboardingPageState extends State<SecondOnboardingPage> {
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
          ProgressIndicatorWidget(),
          const SizedBox(height: 20),
          const TitleWidget(
            title: 'What\'s your height?',
          ),
          const SizedBox(height: 20),
          ToggleButtonsWidget(
            heightUnit: _heightUnit,
            onUnitChanged: (unit) {
              setState(() {
                _heightUnit = unit;
                _updateHeightValues();
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
                          _updateHeightValues(); // Update feet and inches when cm changes
                        });
                      },
                    )
                  : FtInchesPicker(
                      heightFt: _heightFt,
                      heightInches: _heightInches,
                      onFtChanged: (value) {
                        setState(() {
                          _heightFt = value;
                          _updateHeightValues(); // Update cm when feet changes
                        });
                      },
                      onInchesChanged: (value) {
                        setState(() {
                          _heightInches = value;
                          _updateHeightValues(); // Update cm when inches changes
                        });
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          NextButton(onPressed: widget.onNextButtonPressed),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _updateHeightValues() {
    if (_heightUnit == 'ft') {
      // Convert feet and inches to cm
      int cmValue = convertFtInchesToCm(_heightFt, _heightInches);
      // Ensure the cm value is within valid range for CmPicker
      if (cmValue < 95) cmValue = 95;
      if (cmValue > 241) cmValue = 241;

      setState(() {
        _heightCm = cmValue;
      });
    } else {
      // Declare variables with default values
      int ftValue = 3; // Minimum valid feet value
      int inchesValue = 0; // Minimum valid inches value

      convertCmToFtInches(_heightCm, (feet, inches) {
        // Ensure values are within valid ranges
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
