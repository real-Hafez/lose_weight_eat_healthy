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
  double _waterNeeded = 6000.0;
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

  void _handleGoalReached() async {
    final today = DateTime.now();
    final formattedDate = "${today.year}-${today.month}-${today.day}";

    setState(() {
      _goalReachedDays.add(DateTime(today.year, today.month, today.day));
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalReachedDates =
        prefs.getStringList('goal_reached_dates') ?? [];
    if (!goalReachedDates.contains(formattedDate)) {
      goalReachedDates.add(formattedDate);
      await prefs.setStringList('goal_reached_dates', goalReachedDates);
    }
  }

  Future<void> _loadGoalCompletionDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalReachedDates =
        prefs.getStringList('goal_reached_dates') ?? [];

    setState(() {
      _goalReachedDays.clear();
      for (String dateStr in goalReachedDates) {
        final parts = dateStr.split("-");
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        _goalReachedDays.add(DateTime(year, month, day));
      }
    });
  }

  Future<void> get_water_need_and_unit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? value = prefs.getDouble('water_needed');
    String? waterUnit = prefs.getString('water_unit');
    if (value != null) {
      setState(() {
        _waterNeeded = value;
        _savedUnit = waterUnit ?? 'mL';
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
    _loadGoalCompletionDays(); // Load goal completion data
    _updateWidget();
  }

  void _setupWidgetListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateAppState') {
        final waterDrunkInMl = call.arguments as double;
        setState(() {
          _currentIntake = waterDrunkInMl;
        });
        _saveWaterIntake();
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
      print("Failed to update widget: '${e.message}'");
    }
  }

  Future<void> _saveWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_drunk', _currentIntake);
    _updateWidget();
  }

  void _handleUnitChange(String newUnit) async {
    if (_savedUnit != newUnit) {
      final convertedIntake =
          _convertWaterIntake(_currentIntake, _savedUnit!, newUnit);
      final convertedNeeded =
          _convertWaterIntake(_waterNeeded, _savedUnit!, newUnit);

      setState(() {
        _currentIntake = convertedIntake;
        _waterNeeded = convertedNeeded;
        _savedUnit = newUnit;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('water_unit', newUnit);
      await prefs.setDouble('water_drunk', _currentIntake);
      await prefs.setDouble('water_needed', _waterNeeded);

      _updateWidget();
    }
  }

  double _convertWaterIntake(double amount, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return amount;

    double mlAmount;
    switch (fromUnit) {
      case 'L':
        mlAmount = amount * 1000;
        break;
      case 'US oz':
        mlAmount = amount * 29.5735;
        break;
      default: // mL
        mlAmount = amount;
    }

    switch (toUnit) {
      case 'L':
        return mlAmount / 1000;
      case 'US oz':
        return mlAmount / 29.5735;
      default: // mL
        return mlAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_savedUnit == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          WaterIntakeWidget(
            initialIntake: _currentIntake,
            totalTarget: _waterNeeded,
            unit: _savedUnit!,
            onIntakeChange: (newIntake) {
              setState(() {
                _currentIntake = newIntake;
                if (_currentIntake >= _waterNeeded) {
                  _handleGoalReached();
                }
              });
              _saveWaterIntake();
            },
            // onUnitChange: _handleUnitChange,
          ),
          calender_for_training_water(
            goalReachedDays: _goalReachedDays,
          ),
        ],
      ),
    );
  }
}
