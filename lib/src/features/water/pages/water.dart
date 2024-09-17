import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _setupWidgetListener();
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
        return valueInMl / 1000.0; // Convert mL to liters
      case 'US oz':
        return valueInMl * 0.033814; // Convert mL to US ounces
      default:
        return valueInMl; // Keep in mL
    }
  }

  double _convertToMl(double value, String fromUnit) {
    switch (fromUnit) {
      case 'L':
        return value * 1000.0; // Convert liters to mL
      case 'US oz':
        return value / 0.033814; // Convert US ounces to mL
      default:
        return value; // Keep in mL
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
              });
              _updateWidget();
            },
            // onUnitChange: _handleUnitChange,
          ),
        ],
      ),
    );
  }
}
