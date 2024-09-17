// WaterIntakeWidget.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class WaterIntakeWidget extends StatefulWidget {
  final double initialIntake;
  final double totalTarget;
  final String unit;
  final Function(double) onIntakeChange;

  const WaterIntakeWidget({
    super.key,
    required this.initialIntake,
    required this.totalTarget,
    required this.unit,
    required this.onIntakeChange,
  });

  @override
  _WaterIntakeWidgetState createState() => _WaterIntakeWidgetState();
}

class _WaterIntakeWidgetState extends State<WaterIntakeWidget> {
  late double _currentIntake;

  @override
  void initState() {
    super.initState();
    _currentIntake = widget.initialIntake;
  }

  void _incrementIntake() {
    setState(() {
      double incrementAmount = 300.0;
      switch (widget.unit) {
        case 'L':
          incrementAmount = 0.3;
          break;
        case 'US oz':
          incrementAmount = 10.0;
          break;
        default:
          incrementAmount = 300.0;
          break;
      }

      _currentIntake =
          (_currentIntake + incrementAmount).clamp(0, widget.totalTarget);
      widget.onIntakeChange(_currentIntake);
    });
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _currentIntake / widget.totalTarget;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .4,
        child: Stack(
          children: [
            LiquidCircularProgressIndicator(
              value: percentage,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.white,
              borderColor: Colors.red,
              borderWidth: 2.0,
              direction: Axis.vertical,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .06,
                  ),
                  Text(
                    "${(percentage * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Text(
                    "${_formatValue(_currentIntake)} ${widget.unit} / ${_formatValue(widget.totalTarget)} ${widget.unit}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .06,
                  ),
                  IconButton(
                    icon: Icon(
                      Ionicons.add,
                      weight: 100,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * .1,
                    ),
                    onPressed: _incrementIntake,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
