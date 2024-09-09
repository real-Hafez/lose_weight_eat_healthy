import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/buildAnimatedText.dart';

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
  bool _animationFinished = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedTextWidget(
          onFinished: () {
            setState(() {
              _animationFinished = true;
            });
            widget.onAnimationFinished();
          },
          text: 'What water measurement do you use?',
        ),
        const SizedBox(height: 24),
        if (_animationFinished) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Select unit:'),
              const SizedBox(width: 16),
              Expanded(
                child: ToggleButtons(
                  isSelected:
                      _units.map((unit) => unit == _selectedUnit).toList(),
                  onPressed: (int index) {
                    setState(() {
                      _selectedUnit = _units[index];
                    });
                  },
                  children: _units
                      .map((unit) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(unit),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
