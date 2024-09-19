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
  double _waterNeeded = 5000.0; // Mutable now
  double _currentIntake = 0.0;
  static const platform =
      MethodChannel('com.example.lose_weight_eat_healthy/widget');
  final Set<DateTime> _goalReachedDays = {};

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _setupWidgetListener();
    get_water_need_and_unit();
  }

  void _handleGoalReached() {
    final today = DateTime.now();
    setState(() {
      _goalReachedDays
          .add(DateTime(today.year, today.month, today.day)); // Save the day
    });
  }

  Future<void> get_water_need_and_unit() async {
    // Get a reference to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored water needed value
    double? value = prefs.getDouble('water_needed');
    String? waterUnit = prefs.getString('water_unit');

    // Check if the value is not null and update _waterNeeded
    if (value != null) {
      setState(() {
        _waterNeeded = _convertToMl(value, waterUnit ?? 'mL');
        _savedUnit = waterUnit ?? 'mL'; // Ensure unit is set
      });
      print('Retrieved value: $_waterNeeded $_savedUnit');
    } else {
      print('No value found for the key.');
    }
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
        ],
      ),
    );
  }
}
