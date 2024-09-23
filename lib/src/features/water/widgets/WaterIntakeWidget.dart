import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/respontiveRow.dart';

class WaterIntakeWidget extends StatefulWidget {
  final double initialIntake;
  final double totalTarget;
  final String unit;
  final Function(double, double) onIntakeChange;

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

    platform.setMethodCallHandler((call) async {
      if (call.method == "updateAppState") {
        setState(() {
          _currentIntake = (call.arguments as double);
        });
        widget.onIntakeChange(_currentIntake, _currentIntake);
      }
    });
  }

  @override
  void didUpdateWidget(WaterIntakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIntake != oldWidget.initialIntake) {
      setState(() {
        _currentIntake = widget.initialIntake;
      });
    }
  }

  void addWaterIntake(double amount) {
    setState(() {
      double newIntake = (_currentIntake + amount).clamp(0, widget.totalTarget);
      double actualIncrement =
          newIntake - _currentIntake; // Define the increment
      _currentIntake = newIntake;
      widget.onIntakeChange(
          _currentIntake, actualIncrement); // Pass the actual increment

      if (_currentIntake >= widget.totalTarget) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You\'ve reached your daily target!')),
        );
      }
    });

    // Send the incremented amount to the widget
    try {
      platform.invokeMethod(
          'updateWidgetIntake', amount); // Use amount instead of _currentIntake
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  void incrementWaterIntake() {
    double incrementAmount;
    switch (widget.unit) {
      case 'L':
        incrementAmount = 0.3; // 300 mL in liters
        break;
      case 'US oz':
        incrementAmount = 300 / 29.5735; // 300 mL in US ounces
        break;
      case 'mL':
      default:
        incrementAmount = 300; // 300 mL
        break;
    }
    addWaterIntake(incrementAmount);
  }

  String formatValue(double value) {
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _currentIntake / widget.totalTarget;

    return Center(
      child: Column(
        children: [
          SizedBox(
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
                        onPressed: incrementWaterIntake,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResponsiveRow(
                  children: [
                    WaterIntakeCard(
                      onTap: (amount) => addWaterIntake(amount),
                      icon: Icons.water_drop,
                      backgroundColor: Colors.blueAccent,
                      amount: getAmountForUnit(100, widget.unit),
                    ),
                    WaterIntakeCard(
                      onTap: (amount) => addWaterIntake(amount),
                      icon: Icons.local_drink,
                      backgroundColor: Colors.lightBlue,
                      amount: getAmountForUnit(200, widget.unit),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                ResponsiveRow(
                  children: [
                    WaterIntakeCard(
                      onTap: (amount) => addWaterIntake(amount),
                      icon: Icons.local_cafe,
                      backgroundColor: Colors.orangeAccent,
                      amount: getAmountForUnit(400, widget.unit),
                    ),
                    WaterIntakeCard(
                      onTap: (amount) => addWaterIntake(amount),
                      icon: Icons.local_bar,
                      backgroundColor: Colors.purpleAccent,
                      amount: getAmountForUnit(500, widget.unit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getAmountForUnit(double baseAmount, String unit) {
    switch (unit) {
      case 'L':
        return baseAmount / 1000;
      case 'US oz':
        return baseAmount / 29.5735;
      case 'mL':
      default:
        return baseAmount;
    }
  }
}

class WaterIntakeCard extends StatefulWidget {
  final IconData icon;
  final Color backgroundColor;
  final Function(double) onTap;
  final double amount;

  const WaterIntakeCard({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    required this.amount,
  });

  @override
  _WaterIntakeCardState createState() => _WaterIntakeCardState();
}

class _WaterIntakeCardState extends State<WaterIntakeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.amount);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: widget.backgroundColor,
        child: SizedBox(
          height: 120,
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                widget.amount.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
