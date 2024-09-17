import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter/services.dart'; // for MethodChannel

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
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');

  @override
  void initState() {
    super.initState();
    _currentIntake = widget.initialIntake;

    // Listen for updates from the home widget via MethodChannel
    platform.setMethodCallHandler((call) async {
      if (call.method == "updateAppState") {
        setState(() {
          _currentIntake = (call.arguments as double);
        });
        widget.onIntakeChange(_currentIntake); // Notify the parent widget
      }
    });
  }

  // Increment the water intake based on the selected unit
  void incrementIntake() {
    setState(() {
      double incrementAmount;
      switch (widget.unit) {
        case 'L':
          incrementAmount = 0.3; // Increment by 0.3 liters
          break;
        case 'US oz':
          incrementAmount = 10.0; // Increment by 10 US ounces
          break;
        default: // mL
          incrementAmount = 300.0; // Increment by 300 mL
          break;
      }

      _currentIntake =
          (_currentIntake + incrementAmount).clamp(0, widget.totalTarget);
      widget.onIntakeChange(
          _currentIntake); // Call the callback function to update intake

      // Provide feedback
      HapticFeedback
          .lightImpact(); // Trigger vibration feedback when incrementing

      // Optionally, show a message if the target is reached
      if (_currentIntake >= widget.totalTarget) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You’ve reached your daily target!')),
        );
      }
    });

    // Optionally, send the updated value to the native platform or widget if needed
    try {
      platform.invokeMethod('updateWidgetIntake', _currentIntake);
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  // Format the double value for display
  String formatValue(double value) {
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
                    "${formatValue(_currentIntake)} ${widget.unit} / ${formatValue(widget.totalTarget)} ${widget.unit}",
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
                    onPressed: incrementIntake,
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
