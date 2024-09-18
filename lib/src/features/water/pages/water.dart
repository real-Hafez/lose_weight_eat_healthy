import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/widgets/calender_for_training_water.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String? _savedUnit;
  final double _waterNeeded = 2500.0;
  double _currentIntake = 0.0;
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');
  final Set<DateTime> _goalReachedDays = {};

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _setupWidgetListener();
  }

  void _handleGoalReached() {
    final today = DateTime.now();
    setState(() {
      _goalReachedDays
          .add(DateTime(today.year, today.month, today.day)); // Save the day
    });
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUnit = prefs.getString('water_unit') ?? 'mL';
      _currentIntake = prefs.getDouble('water_drunk') ?? 0.0;
    });
    _updateWidget();
  }

  void _setupWidgetListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateAppState') {
        final waterDrunkInMl = call.arguments as double;
        setState(() {
          _currentIntake = waterDrunkInMl;
        });
      }
    });
  }

  Future<void> _updateWidget() async {
    try {
      await platform.invokeMethod('updateWidget', {
        'water': _convertFromMl(_waterNeeded, _savedUnit!),
        'water_drunk': _convertFromMl(_currentIntake, _savedUnit!),
        'unit': _savedUnit,
      });
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'");
    }
  }

  double _convertFromMl(double valueInMl, String toUnit) {
    switch (toUnit) {
      case 'L':
        return valueInMl / 1000.0;
      case 'US oz':
        return valueInMl * 0.033814;
      default:
        return valueInMl;
    }
  }

  double _convertToMl(double value, String fromUnit) {
    switch (fromUnit) {
      case 'L':
        return value * 1000.0;
      case 'US oz':
        return value / 0.033814;
      default:
        return value;
    }
  }

  void _handleUnitChange(String newUnit) {
    setState(() {
      _currentIntake =
          _convertFromMl(_convertToMl(_currentIntake, _savedUnit!), newUnit);
      _savedUnit = newUnit;
    });
    _updateWidget();
  }

  @override
  Widget build(BuildContext context) {
    if (_savedUnit == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final convertedWaterNeeded = _convertFromMl(_waterNeeded, _savedUnit!);
    final convertedCurrentIntake = _convertFromMl(_currentIntake, _savedUnit!);

    return Scaffold(
      body: Column(
        children: [
          WaterIntakeWidget(
            initialIntake: convertedCurrentIntake,
            totalTarget: convertedWaterNeeded,
            unit: _savedUnit!,
            onIntakeChange: (newIntake) {
              setState(() {
                _currentIntake = _convertToMl(newIntake, _savedUnit!);
                if (_currentIntake >= _waterNeeded) {
                  _handleGoalReached();
                }
              });
              _updateWidget();
            },
          ),
          calender_for_training_water(
            goalReachedDays: _goalReachedDays,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ResponsiveRow(
                  children: [
                    WaterIntakeCard(
                      icon: Icons.water_drop,
                      amount: 250,
                      backgroundColor: Colors.blueAccent,
                    ),
                    WaterIntakeCard(
                      icon: Icons.local_drink,
                      amount: 500,
                      backgroundColor: Colors.lightBlue,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                const ResponsiveRow(
                  children: [
                    WaterIntakeCard(
                      icon: Icons.local_cafe,
                      amount: 180,
                      backgroundColor: Colors.orangeAccent,
                    ),
                    WaterIntakeCard(
                      icon: Icons.local_bar,
                      amount: 250,
                      backgroundColor: Colors.purpleAccent,
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
}

class WaterIntakeCard extends StatelessWidget {
  final IconData icon;
  final int amount;
  final Color backgroundColor;

  const WaterIntakeCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.height * .04;
    final textSize = MediaQuery.of(context).size.height * .02;
    final padding = MediaQuery.of(context).size.width * .03;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.blue[900],
          ),
          SizedBox(
            width: padding,
          ),
          Text(
            '$amount ml',
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}
