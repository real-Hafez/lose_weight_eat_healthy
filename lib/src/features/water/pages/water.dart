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
        final waterDrunk = call.arguments as double;
        setState(() {
          _currentIntake = waterDrunk;
        });
      }
    });
  }

  Future<void> _updateWidget() async {
    try {
      await platform.invokeMethod('updateWidget', {
        'water': _waterNeeded,
        'water_drunk': _currentIntake,
        'unit': _savedUnit,
      });
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'.");
    }
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

  void _handleIntakeChange(double newIntake) {
    setState(() {
      _currentIntake = newIntake;
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

    final convertedWaterNeeded = _convertToUnit(_waterNeeded);
    final convertedCurrentIntake = _convertToUnit(_currentIntake);

    return Scaffold(
      body: Column(
        children: [
          WaterIntakeWidget(
            initialIntake: convertedCurrentIntake,
            totalTarget: convertedWaterNeeded,
            unit: _savedUnit!,
            onIntakeChange: _handleIntakeChange,
          ),
        ],
      ),
    );
  }
}
