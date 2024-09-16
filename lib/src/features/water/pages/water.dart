import 'package:flutter/material.dart';
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
  final double _currentIntake = 299.0;

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUnit = prefs.getString('water_unit') ?? 'ml';
    });
  }

  double _convertToUnit(double valueInMl) {
    double convertedValue;

    switch (_savedUnit) {
      case 'L':
        convertedValue = valueInMl / 1000.0;
        break;
      case 'US oz':
        convertedValue = valueInMl * 0.033814;
        break;
      default:
        convertedValue = valueInMl;
        break;
    }

    return double.parse(convertedValue.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    if (_savedUnit == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final convertedWaterNeeded = _convertToUnit(_waterNeeded);
    final convertedCurrentIntake = _convertToUnit(_currentIntake);

    return Scaffold(
      body: Column(
        children: [
          WaterIntakeWidget(
            initialIntake: convertedCurrentIntake,
            totalTarget: convertedWaterNeeded,
            unit: _savedUnit!,
          ),
        ],
      ),
    );
  }
}
